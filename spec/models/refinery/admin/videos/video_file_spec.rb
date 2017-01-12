require 'spec_helper'

module Refinery
  module Videos
    describe VideoFile do

      let(:video_file){FactoryGirl.create(:video_file)}

      context "when external_url is set to true" do
        it 'is invalid without external_url' do
          video_file.file = nil
          video_file.use_external = true
          expect(video_file).to be_invalid
        end

        it 'is valid with an external url' do
          video_file.file = nil
          video_file.use_external = true
          video_file.external_url = 'file.mp4'
          expect(video_file).to be_valid
        end

      end

      context 'when using local files' do

        it 'is invalid without file attribute' do
          video_file.file = nil
          expect(video_file).to be_invalid
        end

        it 'the file attribute refers to an existing file' do
          expect(video_file.exist?).to be_truthy
        end
      end


      it 'should determine mime_type from url' do
        video_file = VideoFile.create(:use_external => true, :external_url => 'www')
        expect(video_file.file_mime_type).to eq('video/mp4')

        video_file.update_attributes(:external_url => 'www.site.com/video.mp4')
        expect(video_file.file_mime_type).to eq('video/mp4')

        video_file.update_attributes(:external_url => 'www.site.com/video.flv')
        expect(video_file.file_mime_type).to eq('video/flv')

        video_file.update_attributes(:external_url => 'www.site.com/video.ogg')
        expect(video_file.file_mime_type).to eq('video/ogg')

        video_file.update_attributes(:external_url => 'www.site.com/video.webm')
        expect(video_file.file_mime_type).to eq('video/webm')
      end

    end
  end
end
