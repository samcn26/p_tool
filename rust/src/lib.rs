use image::{ImageFormat, ImageOutputFormat};

#[no_mangle]
pub extern "C" fn compress_image(path: &str, format: &str, quality: u8) -> Vec<u8> {
    let img = image::open(path).expect("无法打开图片");
    
    let quality = quality.unwrap_or(80).max(1).min(100);
    
    let output_format = match format.to_lowercase().as_str() {
        "jpg" | "jpeg" => ImageOutputFormat::Jpeg(quality),
        "webp" => ImageOutputFormat::WebP,
        "png" => ImageOutputFormat::Png,
        _ => panic!("不支持的格式"),
    };
    
    let mut buffer = Vec::new();
    img.write_to(&mut buffer, output_format).expect("无法压缩图片");
    
    buffer
}