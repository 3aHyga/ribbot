class PagesController < ApplicationController
  before_filter :require_current_forum!
  
  def show
    @page = current_forum.pages.where(:_id =>params[:id]).first
    if @page.nil?
      redirect_to root_path(:subdomain => current_forum.subdomain), :notice => "That page is no longer available."
      return
    elsif @page.exclusive && !signed_in?
      redirect_to signin_path(:subdomain => current_forum.subdomain), :notice => "The page require logged-in user to see it."
      return
    end
  end  
end
