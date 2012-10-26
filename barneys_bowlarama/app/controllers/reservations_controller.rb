class ReservationsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource :only => [:show, :new]

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.includes(:alleys, :user).order(:date).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservations }
    end
  end

  # GET /reservations/serach
  # GET /reservations/search
  def search
    if request.get?
      @office_hour = OfficeHour.by_date Date.today
      @holidays = create_holiday_list
    else
      @alleys = Alley.all
      @reservations = find_possible_reservations params[:search]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservations }
      format.js
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @reservation = Reservation.includes(:alleys, :user).find(params[:id])
    @reservation.alleys.sort_by! {|a| a.number }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.json
  def new
    @alleys = Alley.all
    @office_hour = OfficeHour.by_date Date.today
    @time = next_valid_time
    @reservations = Reservation.by_date(@time.to_date).includes(:alleys)
    @occupation_list = create_occupation_list @reservations, @time
    @reservation_table = create_reservation_table
    @holidays = create_holiday_list
    @reservation = create_reservation_dummy

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/1/edit
  def edit
    @alleys = Alley.all
    @office_hour = OfficeHour.by_date Date.today
    @holidays = Holiday.coming Date.today
    @time = next_valid_time
    @reservations = Reservation.by_date(@time.to_date).includes(:alleys)
    @occupation_list = create_occupation_list @reservations, @time
    @reservation_table = create_reservation_table
    @holiday_list = create_holiday_list
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation.user = current_user
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render json: @reservation, status: :created, location: @reservation }
      else
        @alleys = Alley.all
        @office_hour = OfficeHour.by_date Date.today
        @holidays = Holiday.coming Date.today
        @time = next_valid_time
        @reservations = Reservation.by_date(@time.to_date).includes(:alleys)
        @occupation_list = create_occupation_list @reservations, @time
        @reservation_table = create_reservation_table
        @holiday_list = create_holiday_list

        format.html { render action: "new" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reservations/1
  # PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { head :no_content }
      else
        @alleys = Alley.all
        @office_hour = OfficeHour.by_date Date.today
        @holidays = Holiday.coming Date.today
        @time = next_valid_time
        @reservations = Reservation.by_date(@time.to_date).includes(:alleys)
        @occupation_list = create_occupation_list @reservations, @time
        @reservation_table = create_reservation_table
        @holiday_list = create_holiday_list

        format.html { render action: "edit" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end

  private

  def next_valid_time
    time = Time.now + 1.hour

    if time.min <= 30
      time += (30 - time.min) * 60 - time.sec
    else
      time += (60 - time.min) * 60 - time.sec
    end

    if @office_hour.too_early? time
      time = Time.local(time.year, time.month, time.day, @office_hour.open_from.hour, @office_hour.open_from.min)
    end

    while !(@office_hour.is_open? time)
      date = time.tomorrow
      @office_hour = OfficeHour.by_date date
      time = Time.local(date.year, date.month, date.day, @office_hour.open_from.hour, @office_hour.open_from.min)
    end

    time
  end

  def create_occupation_list(reservations,from,to = from + 1.hour)
    tmp_array = []
    reservations.each do |reservation|
      if reservation.in_conflict? from, to
        reservation.alleys.each do |alley|
          tmp_array << alley.number
        end
      end
    end
    tmp_array.sort
  end

  def create_reservation_table
    tmp_array = []
    @reservations.each do |reservation|
      reservation.alleys.each do |alley|
        tmp_time = reservation.start_time
        begin 
          tmp_array << [alley.number, ((tmp_time - @office_hour.open_from) / 30.minute).floor]
        end while (tmp_time += 30.minute) < reservation.end_time
      end
    end

    tmp_array.sort do |x,y|
      tmp = x[1] <=> y[1]
      if tmp == 0
        x[0] <=> y[0]
      else
        tmp
      end
    end
  end

  def create_holiday_list 
    tmp_array = []
    Holiday.coming(Date.today).each { |h| tmp_array << h.date.strftime("%m-%d-%Y") }
    tmp_array.join(", ")
  end

  def create_reservation_dummy
    if @occupation_list.count == @alleys.count
      nil
    else 
      @alleys.each do |alley|
        if !((alley.id).in? @occupation_list) && alley.unlocked?
          return Reservation.new :date => @time.to_date, :start_time => @time, :end_time => @time + 3600
        end
      end
      nil
    end
  end

  def find_possible_reservations(search)
    @errors = []
    if !(search.has_key?(:date)) || search[:date].blank?
      @errors << "Please choose a Date!"
    end
    if !(search.has_key?(:from)) || search[:from].blank?
      @errors << "Please choose a starting time!"
    end
    if !(search.has_key?(:to)) || search[:to].blank?
      @errors << "Please choose a ending time!"
    end
    if !(search.has_key?(:duration)) || search[:duration].blank?
      @errors << "Please choose a duration!"
    end

    if @errors.empty?
      date = Date.parse params[:search][:date]
      from = Time.parse params[:search][:from]
      to = Time.parse params[:search][:to]
      tmp = params[:search][:duration].split(":")
      duration = tmp[0].to_i * 1.hour + tmp[1].to_i * 1.minute
      reservations = Array.new
      todays_reservations = Reservation.by_date date
      time_iterator = from
      while((time_iterator + duration) <= to)
        occupation_list = create_occupation_list todays_reservations, time_iterator, time_iterator + duration

        unless occupation_list.count == @alleys.count
          r = Reservation.new(:date => date, :start_time => time_iterator, :end_time => time_iterator + duration)
          @alleys.each do |alley|
            unless occupation_list.include? alley.number.to_i
              r.alley_reservations.build(:alley => alley)
            else
              r.alley_reservations.build(:alley => alley).set_occupied
            end
          end
          r.alley_reservations.sort_by! {|x| x.alley.id }
          reservations << r
        end
        time_iterator += 30.minute
      end
      reservations
    end
  end
end
