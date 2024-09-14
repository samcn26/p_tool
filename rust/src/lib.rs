use image::codecs::jpeg::JpegEncoder;
use image::codecs::png::PngEncoder;
use image::codecs::webp::WebPEncoder;
use image::{GenericImageView, ImageEncoder, ColorType};

#[no_mangle]
pub extern "C" fn compress_image(path: &str, format: &str, quality: Option<u8>) -> Vec<u8> {
    let img = image::open(path).expect("无法打开图片");

    // 如果没有传递 quality，则使用默认值 80
    let quality = quality.unwrap_or(80).max(1).min(100);

    let mut buffer = Vec::new();
    let (width, height) = img.dimensions();

    // 将图像转换为 RGBA8 格式
    let img_buffer = img.to_rgba8();
    let img_data = img_buffer.as_raw();
    let color_type = ColorType::Rgba8;

    match format.to_lowercase().as_str() {
        "jpg" | "jpeg" => {
            let mut encoder = JpegEncoder::new_with_quality(&mut buffer, quality);
            encoder.encode(&img_data, width, height, color_type.into()).expect("无法压缩JPEG图片");
        },
        "webp" => {
            let mut encoder = WebPEncoder::new_lossless(&mut buffer);
            encoder.encode(&img_data, width, height, color_type.into()).expect("无法压缩WebP图片");
        },
        "png" => {
            let encoder = PngEncoder::new(&mut buffer);
            encoder.write_image(&img_data, width, height, color_type.into()).expect("无法压缩PNG图片");
        },
        _ => panic!("不支持的格式"),
    };

    buffer
}
