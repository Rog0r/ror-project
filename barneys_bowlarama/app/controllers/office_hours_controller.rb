# encoding: UTF-8

class OfficeHoursController < ApplicationController
  load_and_authorize_resource

  # GET /office_hours
  # GET /office_hours.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @office_hours }
    end
  end

  # GET /office_hours/1/edit
  def edit
  end

  # PUT /office_hours/1
  # PUT /office_hours/1.json
  def update
    params[:office_hour].delete "day"

    respond_to do |format|
      if @office_hour.update_attributes(params[:office_hour])
        format.html { redirect_to action: "index", notice: 'Offnungszeit erfolgreich geändert.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

end
