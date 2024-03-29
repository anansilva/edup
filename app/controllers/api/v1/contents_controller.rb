class Api::V1::ContentsController < ApplicationController

  acts_as_token_authentication_handler_for Publisher

  before_action do
    if current_publisher != nil
      authenticate_publisher!
    else
      authenticate_student!
    end
  end


  def create
    @course = Course.find(params[:course_id])
    @content = Content.new(content_params)
    @content.save
    @course_content = CourseContent.new
    @course_content.course = @course
    @course_content.content_id = @content.id
     if @course_content.save
       redirect_to api_v1_courses_path
    else
      render :new
    end
  end

 private

  def content_params
    params.require(:content).permit(:name, :description, :video, :video_link)
  end
end

