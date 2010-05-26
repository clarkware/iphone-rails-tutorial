# START:nested
class CreditsController < ApplicationController
# END:nested  
  before_filter :login_required
# START:nested

  before_filter :find_goal
# END:nested
  
  def index
    @credits = @goal.credits.all

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @credits }
      format.json { render :json => @credits }
    end
  end
# START:nested

  def show
    @credit = @goal.credits.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @credit }
      format.json { render :json => @credit }
    end
  end
# END:nested

  def new
    @credit = @goal.credits.build

    respond_to do |format|
      format.html
      format.xml  { render :xml  => @credit }
      format.json { render :json => @credit }
    end
  end

  def edit
    @credit = @goal.credits.find(params[:id])
  end

  def create
    @credit = @goal.credits.build(params[:credit])

    respond_to do |format|
      if @credit.save
        format.html { redirect_to @goal }
        format.xml  { render :xml => @credit, :status => :created, :location => [@goal, @credit] }
        format.json { render :json => @credit, :status => :created, :location => [@goal, @credit] }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml  => @credit.errors, :status => :unprocessable_entity }
        format.json { render :json => @credit.errors, :status => :unprocessable_entity }
        format.js do
          render :update do |page| 
            flash[:error] = @credit.errors.full_messages.to_sentence
            page.redirect_to @goal 
          end
        end
      end
    end
  end

  def update
    @credit = @goal.credits.find(params[:id])

    respond_to do |format|
      if @credit.update_attributes(params[:credit])
        format.html { redirect_to @goal }
        format.any(:xml, :json) { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @credit.errors, :status => :unprocessable_entity }
        format.json { render :json => @credit.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @credit = @goal.credits.find(params[:id])
    @credit.destroy

    respond_to do |format|
      format.html { redirect_to @goal }
      format.js   { render 'create'}
      format.any(:xml, :json) { head :ok }
    end
  end
# START:nested
  
protected

  def find_goal
    @goal = current_user.goals.find(params[:goal_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid goal."
    redirect_to @goal
  end
  
end
# END:nested
