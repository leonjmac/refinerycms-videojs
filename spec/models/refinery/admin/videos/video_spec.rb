require 'spec_helper'

module Refinery
  module Videos
    describe Video do

      describe 'Validation' do

        describe 'A video without a source' do
          subject { FactoryGirl.build(:video) }
          before { subject.valid? }
          it 'returns error "Please select at least one source"' do
            expect(subject.errors.messages).to include(video_files: ["Please select at least one source"])
          end
        end

        describe 'A shared video without an embed tag' do
          subject { FactoryGirl.build(:video, use_shared: true) }
          before {subject.valid? }
          it 'returns error "Please embed a video"' do
            expect(subject.errors.messages).to include(embed_tag: ['Please embed a video'])
          end
        end

        describe 'A shared video with an embed tag' do
          subject { FactoryGirl.build(:video, use_shared: true, embed_tag: '<iframe></iframe>') }
          it 'is a valid video' do
            expect(subject).to be_valid
          end
        end

        describe 'A video with an attached source file' do
          let(:video_file) { FactoryGirl.build(:video_file) }
          let(:video) { FactoryGirl.build(:video, use_shared: false) }
          before {video.video_files << video_file}

          it 'is a valid video' do
            expect(video).to be_valid
          end
        end
      end

      describe 'Configuration' do
        let(:video) { FactoryGirl.build(:video, use_shared: true, embed_tag: '<iframe></iframe>') }

        context 'get option' do
          before { video.config = { height: 100 } }
          it 'should return config option' do
            expect(video.height).to eq(video.config[:height])
          end
        end

        context 'set option' do
          before { video.config = { height: 100 } }
          it 'should change config option' do
            expect { video.height = 200 }.to change { video.config[:height] }.from(100).to(200)
          end
        end

        context 'set default config when created' do
          let(:video) { Video.new }
          it 'should have config' do
            expect(video.config.class).to eq(Hash)
            expect(video.config[:preload]).to eq('true')
          end
        end

        context 'should save config' do
          let(:video) { Video.new(use_shared: true, embed_tag: 'video', title: 'video') }
          it 'should save height' do
            video.config[:height] = 100
            video.save!
            expect(video.config[:height]).to eq(100)
          end
        end

      end

      describe 'video to_html method' do
        context 'with file' do
          let(:video_file) { FactoryGirl.build(:video_file) }
          let(:video) { Video.new(use_shared: false) }
          before do
            allow(video_file).to receive(:url).and_return('url_to_video_file')
            video.video_files << video_file
          end
          it 'should return video tag with source' do
            puts video.to_html
            expect(video.to_html).to match(/^<video.*<\/video>$/)
            expect(video.to_html).to match(/<source src=["']url_to_video_file['"]/)
            expect(video.to_html).to match(/data-setup/)
          end
        end

        context 'with embedded video' do
          let(:video) do
            FactoryGirl.create(
              :video,
              use_shared: true,
              embed_tag: "<iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/L5J8cIQHlnY\" frameborder=\"0\" allowfullscreen></iframe>")
          end

          it 'should return video tag with iframe' do
            expect(video.to_html).to match(/^<iframe.*<\/iframe>$/)
            expect(video.to_html).to match(/www\.youtube\.com/)
            expect(video.to_html).to match(/wmode=transparent/)
          end

          before do
            video.config[:height] = 111
            video.config[:width] = 222
          end

          it 'should set config from config before return tag' do
            expect(video.to_html).to match(/222.*111/)
          end
        end
      end

      describe 'short_info' do

        describe 'online video short info' do
          let(:video) { FactoryGirl.build(:video, use_shared: true, embed_tag: '<iframe></iframe>') }
          it 'will include "shared_source"' do
            expect(video.short_info.to_s).to match(/.shared_source/i)
          end
        end
        describe 'local video short info' do
          let(:video) { FactoryGirl.build(:video, use_shared: false) }
          let(:video_file) { FactoryGirl.build(:video_file, use_external: false) }
          it 'will include a file list' do
            video.video_files << video_file
            expect(video.short_info.to_s).to match(/.file/i)
          end
        end
      end
    end
  end
end
