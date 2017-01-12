require 'spec_helper'

describe Refinery::Videos::Admin::VideosController,  type: :controller do

  let(:logged_in_user) { Refinery::Core::NilUser.new }

  describe 'insert video' do
    let!(:video) { FactoryGirl.create(:valid_video, title: "TestVideo")}

    it 'renders the insert template' do
      get :insert, app_dialog: true, dialog: true
      expect(response).to render_template(:insert)
    end

    it 'gets a video' do
      get :insert, app_dialog: true, dialog: true
      expect(assigns(:videos)).to eq([video])
    end

    it 'offers a preview' do
      xhr :get, :dialog_preview, id: "video_#{video.id}", format: :js
      expect(response).to be_success
      expect(response).to render_template(:dialog_preview)
    end

    it 'inserts the video into the editor' do
      post :append_to_wym, video_id: video.id, 'video': {'height': '100'}, format: :js
      expect(response).to be_success
    end

  end

end
