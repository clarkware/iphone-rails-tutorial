class GoalsController < ApplicationController
  # GET /goals
  # GET /goals.xml
  def index
    @goals = Goal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goals }
      format.json { render :json => @goals }
    end
  end

  # GET /goals/1
  # GET /goals/1.xml
  def show
    @goal = Goal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @goal }
      format.json { render :json => @goal }
    end
  end

  # GET /goals/new
  # GET /goals/new.xml
  def new
    @goal = Goal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @goal }
      format.json { render :json => @goal }
    end
  end

  # GET /goals/1/edit
  def edit
    @goal = Goal.find(params[:id])
  end

  # POST /goals
  # POST /goals.xml
  def create
    @goal = Goal.new(params[:goal])

    respond_to do |format|
      if @goal.save
        format.html { redirect_to(@goal, :notice => 'Goal was successfully created.') }
        format.xml  { render :xml  => @goal, :status => :created, :location => @goal }
        format.json { render :json => @goal, :status => :created, :location => @goal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml  => @goal.errors, :status => :unprocessable_entity }
        format.json { render :json => @goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /goals/1
  # PUT /goals/1.xml
  def update
    @goal = Goal.find(params[:id])

    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        format.html { redirect_to(@goal, :notice => 'Goal was successfully updated.') }
        format.xml  { render :xml  => @goal, :status => 200 }
        format.json { render :json => @goal, :status => 200 }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @goal.errors, :status => :unprocessable_entity }
        format.json { render :json => @goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.xml
  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to(goals_url) }
      format.xml  { render :xml  => @goal, :status => 200 }
      format.json { render :json => @goal, :status => 200 }
    end
  end
end
