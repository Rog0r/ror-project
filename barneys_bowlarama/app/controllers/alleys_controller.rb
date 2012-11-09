# encoding: UTF-8

class AlleysController < ApplicationController
  load_and_authorize_resource
  # GET /alleys
  # GET /alleys.json
  def index
    @alleys = Alley.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @alleys }
    end
  end

  # GET /alleys/new
  # GET /alleys/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @alley }
    end
  end

  # GET /alleys/1/edit
  def edit
  end

  # POST /alleys
  # POST /alleys.json
  def create
    respond_to do |format|
      if @alley.save
        format.html { redirect_to @alley, notice: 'Bahn erfolgreich angelegt.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /alleys/1
  # PUT /alleys/1.json
  def update
    respond_to do |format|
      if @alley.update_attributes(params[:alley])
        format.html { redirect_to @alley, notice: 'Bahn erfolgreich geändert.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /alleys/1
  # DELETE /alleys/1.json
  def destroy
    @alley.destroy

    respond_to do |format|
      format.html { redirect_to alleys_url }
      format.json { head :no_content }
    end
  end
end
