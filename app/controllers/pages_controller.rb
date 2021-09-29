class PagesController < ApplicationController
  before_action :set_octokit

  def index
    repo = params[:repo] || 'developer-portal'
    @pull_requests = @client.pulls("department-of-veterans-affairs/#{repo}", per_page: 100, state: 'all')
    @start_at = Date.strptime('2021-05-02', '%Y-%m-%d').beginning_of_month
    @end_at = Date.strptime('2021-05-02', '%Y-%m-%d').end_of_month
    @pull_requests_in_frame, @pull_request_time, @merged_pulls = filter_pull_requests
  end

  private

  def set_octokit
    @client ||= Octokit::Client.new(access_token: '')
  end

  def filter_pull_requests
    pull_requests = []
    pull_request_time = 0
    merged_pulls = 0
    @pull_requests.each do |pull_request|
      if pull_request[:created_at] >= @start_at && pull_request[:created_at] <= @end_at
        pull_requests << pull_request
        pull_request_time = pull_request_time + (pull_request.merged_at - pull_request.created_at) if pull_request.merged_at.present?
        merged_pulls += 1 if pull_request.merged_at.present?
      end
    end
    [pull_requests, pull_request_time, merged_pulls]
  end
end
