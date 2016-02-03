module CommentsHelper
  def add_lightbox(html)
    doc = Nokogiri::HTML::DocumentFragment.parse(html, nil)
    doc.search('img').each do |img|
      link = Nokogiri::XML::Node::new('a', doc)
      link['href'] = original_file_path(img['src'])
      link['data-lightbox'] = original_file_path(img['src'])
      img_tag = img.clone
      link.add_child img_tag
      img.replace link
    end
    return doc.to_html
  end
  private
  def original_file_path(path)
    file_name = File.basename(path)
    dir_name = File.dirname(path)
    original_file_name = file_name.sub(/(large_)|(small_)|(medium_)/,'')
    return dir_name +'/'+ original_file_name
  end
end
