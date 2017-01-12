require 'spec_helper'

describe Refinery::Videos::Admin::VideoFilesController, type: :controller do
  let(:logged_in_user) { Refinery::Core::NilUser.new }

  describe 'delete video file' do
    let!(:video_file) {FactoryGirl.create(:video_file, external_url: 'url', use_external: true)}
    let!(:video) {FactoryGirl.build(:video, use_shared: false)}

    before (:each) do
      video.video_files << video_file
      video.save!
    end

    it 'deletes the video_file' do
      post :destroy, id: video_file.id
      expect(::Refinery::Videos::VideoFile.count).to eq(0)
    end

    it 'redirects to the video previously associated with the file' do
      post :destroy, id: video_file.id
      expect(response.status).to redirect_to(refinery.edit_videos_admin_video_path(video))
    end

  end

end
