class  API::MembersController < ApplicationController
  before_action :set_member, only: %i[ show update destroy ]

  # GET /members
  # GET /members.json
  def index
    @members = Member.all
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    if @member.save
      render :show, status: :created, location: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    if @member.update(member_params)
      render :show, status: :ok, location: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def member_params
      @member_params ||= params.expect(member: [ :access_level, :user_id, :created_by_id, :namespace_id ])
    end
end
