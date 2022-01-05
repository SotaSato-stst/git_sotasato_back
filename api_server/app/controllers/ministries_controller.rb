class MinistriesController < ApplicationController
  def index
    @ministries = Ministry.all
  end
end
