
FactoryGirl.define do
  factory :video_file, :class => ::Refinery::Videos::VideoFile do
    file Refinery.roots.join("spec/fixtures/video.flv")
  end

end
