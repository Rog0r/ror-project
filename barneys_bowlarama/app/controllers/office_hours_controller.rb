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

  # GET /office_hours/1
  # GET /office_hours/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @office_hour }
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
        format.html { redirect_to @office_hour, notice: 'Office hour was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @office_hour.errors, status: :unprocessable_entity }
      end
    end
  end

end
