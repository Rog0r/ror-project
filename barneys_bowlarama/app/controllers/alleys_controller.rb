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

  # GET /alleys/1
  # GET /alleys/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @alley }
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
        format.html { redirect_to @alley, notice: 'Alley was successfully created.' }
        format.json { render json: @alley, status: :created, location: @alley }
      else
        format.html { render action: "new" }
        format.json { render json: @alley.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /alleys/1
  # PUT /alleys/1.json
  def update
    respond_to do |format|
      if @alley.update_attributes(params[:alley])
        format.html { redirect_to @alley, notice: 'Alley was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @alley.errors, status: :unprocessable_entity }
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
