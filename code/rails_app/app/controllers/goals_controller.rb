# START:authentication
class GoalsController < ApplicationController

  before_filter :login_required

  def index
    @goals = current_user.goals.all

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @goals }
      format.json { render :json => @goals }
    end
  end

# END:authentication

  def show
    @goal = current_user.goals.find(params[:id])
    @credit = Credit.new

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @goal }
      format.json { render :json => @goal }
    end
  end
  
  def new
    @goal = current_user.goals.build

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @goal }
      format.json { render :json => @goal }
    end
  end

  def edit
    @goal = current_user.goals.find(params[:id])
  end

  def create
    @goal = current_user.goals.build(params[:goal])

    respond_to do |format|
      if @goal.save
        format.html { redirect_to @goal }
        format.xml  { render :xml  => @goal, :status => :created, :location => @goal }
        format.json { render :json => @goal, :status => :created, :location => @goal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @goal.errors, :status => :unprocessable_entity }
        format.json { render :xml => @goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @goal = current_user.goals.find(params[:id])

    respond_to do |format|
      if @goal.update_attributes(params[:goal])
        format.html { redirect_to @goal }
        format.any(:xml, :json) { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @goal.errors, :status => :unprocessable_entity }
        format.json { render :json => @goal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @goal = current_user.goals.find(params[:id])
    @goal.destroy

    respond_to do |format|
      format.html { redirect_to(goals_url) }
      format.any(:xml, :json) { head :ok }
    end
  end
    
# START:authentication
end
# END:authentication

