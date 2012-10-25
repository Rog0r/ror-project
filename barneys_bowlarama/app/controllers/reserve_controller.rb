class ReserveController < ApplicationController
  def pick
    @alleys = Alley.all
    @office_hour = OfficeHour.where(:day => Date.today.strftime("%A")).first
    @holidays = Holiday.where("date > ?", Date.today)
    @time = next_valid_time

    @reservations = Reservation.by_date(@time.to_date).includes(:alleys)
    @occupation_list = create_occupation_list
    @reservation_table = create_reservation_table
    @holiday_list = create_holiday_list
    @current_reservation = create_current_reservation_dummy

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @alleys }
    end
  end

  def search
  end

  private

  def next_valid_time
    time = Time.now + 3600

    if time.strftime("%H%M") < @office_hour.open_from.strftime("%H%M")
      time = Time.local(time.year, time.month, time.day, @office_hour.open_from.hour, @office_hour.open_from.min)
    end

    while time.strftime("%H%M") < @office_hour.open_from.strftime("%H%M") || time.strftime("%H%M") > @office_hour.open_to.strftime("%H%M")
      date = time.tomorrow
      @office_hour = OfficeHour.where(:day => date.strftime("%A")).first
      time = Time.local(date.year, date.month, date.day, @office_hour.open_from.hour, @office_hour.open_from.min)
    end

    if time.min <= 30
      time += (30 - time.min) * 60 - time.sec
    else
      time += (60 - time.min) * 60 - time.sec
    end
  end

  def create_occupation_list
    tmp_array = []
    @reservations.each do |reservation|
      if @time.strftime("%H%M") >= reservation.start_time.strftime("%H%M") && @time.strftime("%H%M") <= reservation.end_time.strftime("%H%M")
        reservation.alleys.each do |alley|
          tmp_array << alley.number
        end
      end
    end
    tmp_array.sort!
  end

  def create_reservation_table
    tmp_array = []
    @reservations.each do |reservation|
      reservation.alleys.each do |alley|
        tmp_time = reservation.start_time
        begin 
          tmp_array << [alley.number, ((tmp_time - @office_hour.open_from) / 1800).floor]
        end while (tmp_time += 1800) < reservation.end_time
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
    @holidays.each { |h| tmp_array << h.date.strftime("%m-%d-%Y") }
    tmp_array.join(", ")
  end

  def create_current_reservation_dummy
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

end
