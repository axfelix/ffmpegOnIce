class VideoUploader < CarrierWave::Uploader::Base

  require 'streamio-ffmpeg'
  include CarrierWave::Video
    version :reverse, if: :is_reverse? do
      process encode_video: [:webm,
        resolution: "1280x960",
        custom: %w(-c:v libvpx-vp9 -to 5 -vf reverse)]
    end
    version :tile, if: :is_tile? do
      process encode_video: [:webm,
        resolution: "1280x960",
        custom: %w(-c:v libvpx-vp9 -to 5 -vf scale=iw/4:ih/4:force_original_aspect_ratio=decrease,tile=4x4:overlap=4*4-1:init_padding=4*4-1)]
    end
    version :pseudocolor, if: :is_pseudocolor? do
      process encode_video: [:webm,
        resolution: "1280x960",
        custom: %w(-c:v libvpx-vp9 -to 5 -filter_complex eq=brightness=0.40:saturation=8,pseudocolor='if(between(val,ymax,amax),lerp(ymin,ymax,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(umax,umin,(val-ymax)/(amax-ymax)),-1):if(between(val,ymax,amax),lerp(vmin,vmax,(val-ymax)/(amax-ymax)),-1):-1')]
    end
    version :lagfun, if: :is_lagfun? do
      process encode_video: [:webm,
        resolution: "1280x960",
        custom: %w(-c:v libvpx-vp9 -to 5 -filter_complex format=gbrp10[formatted];[formatted]split[a][b];[a]lagfun=decay=.99:planes=1[a];[b]lagfun=decay=.98:planes=2[b];[a][b]blend=all_mode=screen:c0_opacity=.5:c1_opacity=.5,format=yuv422p10le[out] -map [out])]
    end
    version :jetcolor, if: :is_jetcolor? do
      process encode_video: [:webm,
        resolution: "1280x960",
        custom: %w(-c:v libvpx-vp9 -to 5 -filter_complex format=gbrp10le,eq=brightness=0.40:saturation=8,pseudocolor='if(between(val,0,85),lerp(45,159,(val-0)/(85-0)),if(between(val,85,170),lerp(159,177,(val-85)/(170-85)),if(between(val,170,255),lerp(177,70,(val-170)/(255-170))))):if(between(val,0,85),lerp(205,132,(val-0)/(85-0)),if(between(val,85,170),lerp(132,59,(val-85)/(170-85)),if(between(val,170,255),lerp(59,100,(val-170)/(255-170))))):if(between(val,0,85),lerp(110,59,(val-0)/(85-0)),if(between(val,85,170),lerp(59,127,(val-85)/(170-85)),if(between(val,170,255),lerp(127,202,(val-170)/(255-170))))):i=0',format=yuv422p10le)]
    end
    version :bitplaneslices, if: :is_bitplaneslices? do
      process encode_video: [:webm,
        resolution: "1280x960",
        custom: %w(-c:v libvpx-vp9 -to 5 -vf format=yuv420p10le|yuv422p10le|yuv444p10le|yuv440p10le,split=10[b0][b1][b2][b3][b4][b5][b6][b7][b8][b9];[b0]crop=iw/10:ih:(iw/10)*0:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-1))*pow(2\,1)[b0c];[b1]crop=iw/10:ih:(iw/10)*1:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-2))*pow(2\,2)[b1c];[b2]crop=iw/10:ih:(iw/10)*2:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-3))*pow(2\,3)[b2c];[b3]crop=iw/10:ih:(iw/10)*3:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-4))*pow(2\,4)[b3c];[b4]crop=iw/10:ih:(iw/10)*4:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-5))*pow(2\,5)[b4c];[b5]crop=iw/10:ih:(iw/10)*5:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-6))*pow(2\,6)[b5c];[b6]crop=iw/10:ih:(iw/10)*6:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-7))*pow(2\,7)[b6c];[b7]crop=iw/10:ih:(iw/10)*7:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-8))*pow(2\,8)[b7c];[b8]crop=iw/10:ih:(iw/10)*8:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-9))*pow(2\,9)[b8c];[b9]crop=iw/10:ih:(iw/10)*9:0,lutyuv=y=512:u=512:v=512:y=bitand(val\,pow(2\,10-10))*pow(2\,10)[b9c];[b0c][b1c][b2c][b3c][b4c][b5c][b6c][b7c][b8c][b9c]hstack=10,format=yuv422p10le,drawgrid=w=iw/10:h=ih:t=2:c=cyan@1)]
    end

  def full_filename(for_file)
    super.chomp(File.extname(super)) + '.mp4'
  end
  def filename
    original_filename.chomp(File.extname(original_filename)) + '.mp4'
  end
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

private

  def is_reverse? title
    model.title == 'reverse'
  end

  def is_tile? title
    model.title == 'tile'
  end

  def is_pseudocolor? title
    model.title == 'pseudocolor'
  end

  def is_lagfun? title
    model.title == 'lagfun'
  end

  def is_jetcolor? title
    model.title == 'jetcolor'
  end

  def is_bitplaneslices? title
    model.title == 'bitplaneslices'
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, 4)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
