# encoding: utf-8
require "spec_helper"
module Refinery
  module Videos
    describe 'Admin', type: :feature do
      let(:logged_in_user) { Refinery::Core::NilUser.new }

      describe 'videos' do

        describe 'videos list' do
          before(:each) do
            FactoryGirl.create(:video, title: 'UniqueTitleOne', use_shared: true, embed_tag: '<iframe></iframe>')
            FactoryGirl.create(:video, title: 'UniqueTitleTwo', use_shared: true, embed_tag: '<iframe></iframe>')
          end

          it "shows two items" do
            visit refinery.videos_admin_videos_path
            expect(page).to have_content("UniqueTitleOne")
            expect(page).to have_content("UniqueTitleTwo")
          end
        end

        describe "create", js: true do
          before(:each) do
            visit refinery.videos_admin_videos_path
            find_link('Add New Video').trigger('click')
          end

          context "Embedded video" do
            it "adds the embedded video" do
              click_link "Use embedded video"
              fill_in "video_title", with: "Test Video"
              fill_in "video_embed_tag", with: '<iframe src="http://player.vimeo.com/video/39432556" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
              click_button "Save"

              expect(page).to have_content("'Test Video' was successfully added.")
              expect(Refinery::Videos::Video.count).to eq(1)
            end
          end

          context "Video with url" do
            it "adds the video with external url" do
              fill_in "video_title", with: "Test Video"
              choose 'Use external source'
              fill_in 'video_video_files_attributes_0_external_url', with: 'url'
              click_button "Save"
              expect(page).to have_content("'Test Video' was successfully added.")
              expect(Refinery::Videos::Video.count).to eq(1)
            end
          end


          context "Video with local files" do
            it "adds the video with associated files" do
              fill_in "video_title", with: "Test Video"
              attach_file('video_video_files_attributes_0_file', 'spec/fixtures/video.flv')
              click_button "Save"
              expect(page).to have_content("'Test Video' was successfully added.")
              expect(Refinery::Videos::Video.count).to eq(1)
            end
          end

        end

        describe "edit" do
          before(:each) { FactoryGirl.create(:video, title: "Test Video", use_shared: true, embed_tag: '<iframe></iframe>') }

          it 'can change video attributes' do
            visit refinery.videos_admin_videos_path
            within ".actions" do
              click_link "Edit this video"
            end
            fill_in "video_title", with: "A different file_name"
            click_button "Save"
            expect(page).to have_content("'A different file_name' was successfully updated.")
            expect(page).to have_no_content("Test Video")
            expect(page).to have_content("A different file_name")
          end
        end

        describe "destroy" do
          before(:each) { FactoryGirl.create(:video, title: "UniqueTitleOne", use_shared: true, embed_tag: '<iframe></iframe>') }
          it "should succeed" do
            visit refinery.videos_admin_videos_path
            click_link "Remove this video forever"
            expect(page).to have_content("'UniqueTitleOne' was successfully removed.")
            expect(Refinery::Videos::Video.count).to eq(0)
          end
        end

        describe "insert video" do
          before(:each) do
            FactoryGirl.create(:video, title: "Test Video1", use_shared: true, embed_tag: 'external_video1')
            FactoryGirl.create(:video, title: "Test Video2", use_shared: true, embed_tag: 'external_video2')
          end
          it "should show list of available video" do
            visit refinery.insert_videos_admin_videos_path
            expect(page).to have_content("Test Video1")
            expect(page).to have_content("Test Video2")
          end

        end

      end
    end
  end
end
