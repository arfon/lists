class HomeController < ApplicationController
  before_action :require_user, :only => %w(profile)

  def index
    puts "Lists!"
  end

  def profile
    @user = current_user
  end
end
