# encoding: utf-8
require 'spec_helper'
module Refinery
  module Videos
    describe 'Admin', type: :feature do
      let(:logged_in_user) { Refinery::Core::NilUser.new }

      describe 'videos' do

        describe 'index' do
          let!(:video1) {FactoryGirl.create(:video, title: 'UniqueTitleOne', use_shared: true, embed_tag: '<iframe></iframe>')}
          let!(:video2) {FactoryGirl.create(:video, title: 'UniqueTitleTwo', use_shared: true, embed_tag: '<iframe></iframe>')}

          it 'shows all videos' do
            visit refinery.videos_admin_videos_path
            expect(page).to have_content("UniqueTitleOne")
            expect(page).to have_content("UniqueTitleTwo")
          end
        end

        describe 'create', js: true do
          before(:each) do
            visit refinery.videos_admin_videos_path
            find_link('Add New Video').trigger('click')
          end

          context 'Embedded video' do
            it 'adds the embedded video' do
              click_link 'Use embedded video'
              fill_in 'video_title', with: 'Test Video'
              fill_in 'video_embed_tag', with: '<iframe src="http://player.vimeo.com/video/39432556" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
              click_button 'Save'

              expect(page).to have_content("'Test Video' was successfully added.")
              expect(Refinery::Videos::Video.count).to eq(1)
            end
          end

          context 'Video with url' do
            it 'adds the video with external url' do
              fill_in 'video_title', with: 'Test Video'
              choose 'Use external source'
              fill_in 'video_video_files_attributes_0_external_url', with: 'url'
              click_button 'Save'
              expect(page).to have_content("'Test Video' was successfully added.")
              expect(Refinery::Videos::Video.count).to eq(1)
            end
          end


          context 'Video with local files' do
            it 'adds the video with associated files' do
              fill_in 'video_title', with: 'Test Video'
              attach_file('video_video_files_attributes_0_file', 'spec/fixtures/video.flv')
              click_button 'Save'
              expect(page).to have_content("'Test Video' was successfully added.")
              expect(Refinery::Videos::Video.count).to eq(1)
            end
          end

        end

        describe 'edit' do
          let!(:video) {FactoryGirl.create(:video, title: 'Test Video', use_shared: true, embed_tag: '<iframe></iframe>')}
          it 'changes video attributes' do
            visit refinery.videos_admin_videos_path
            within '.actions' do
              click_link 'Edit this video'
            end
            fill_in 'video_title', with: 'A different file_name'
            click_button 'Save'
            expect(page).to have_content("'A different file_name' was successfully updated.")
            expect(page).to have_no_content("Test Video")
          end
        end

        describe 'destroy'  do
          let!(:video) {FactoryGirl.create(:video, title: 'UniqueTitleOne', use_shared: true, embed_tag: '<iframe></iframe>')}

          it 'deletes the video' do
            visit refinery.videos_admin_videos_path
            click_link 'Remove this video forever'
            expect(Refinery::Videos::Video.count).to eq(0)
          end

          it 'shows a success message' do
            visit refinery.videos_admin_videos_path
            click_link 'Remove this video forever'
            expect(page).to have_content("'UniqueTitleOne' was successfully removed.")
          end
        end

        describe 'insert video' do
          let!(:video1) {FactoryGirl.create(:video, title: 'Test Video1', use_shared: true, embed_tag: '<iframe></iframe>')}
          let!(:video2) {FactoryGirl.create(:video, title: 'Test Video2', use_shared: true, embed_tag: '<iframe></iframe>')}
          it 'shows available videos' do
            visit refinery.insert_videos_admin_videos_path
            expect(page).to have_content("Test Video1")
            expect(page).to have_content("Test Video2")
          end
        end

        end
    end
  end
end
