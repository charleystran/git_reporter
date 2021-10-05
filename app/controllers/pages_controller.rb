class PagesController < ApplicationController

  def index
  end

  def show
    @repo = Repository.find(params[:id])
    @pull_requests = client.pulls(repo, per_page: 100, state: 'all')
    @pull_requests_in_frame, @pull_request_time, @merged_pulls = filter_pull_requests
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: Figaro.env.github_access_token)
  end

  def filter_pull_requests
    pull_requests = []
    pull_request_time = 0
    merged_pulls = 0
    @pull_requests.each do |pull_request|
      if pull_request[:created_at] >= start_day && pull_request[:created_at] <= end_day
        pull_requests << pull_request
        pull_request_time = pull_request_time + (pull_request.merged_at - pull_request.created_at) if pull_request.merged_at.present?
        merged_pulls += 1 if pull_request.merged_at.present?
      end
    end
    [pull_requests, pull_request_time, merged_pulls]
  end

  def start_day
    params[:start_day] || (Date.today - 30.days)
  end

  def end_day
    params[:start_day] || Date.today
  end
end
