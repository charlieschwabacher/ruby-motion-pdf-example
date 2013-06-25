class PDFPageViewController < UIViewController
  
  def initialize(page)
    @page = page
  end

  def loadView
    super
    self.view = PDFPageView.new(@page).initWithFrame UIScreen.mainScreen.bounds
  end

end


class PDFPageView < UIView

  def initialize(page)
    @page = page
  end

  def drawRect(rect)

    context = UIGraphicsGetCurrentContext()

    # clear rect
    UIColor.whiteColor.set
    CGContextFillRect context, rect

    # flip coordinates
    CGContextScaleCTM context, 1, -1
    CGContextTranslateCTM context, 0, -rect.size.height

    # apply transform to draw rect
    pageRect = CGPDFPageGetBoxRect @page, 3
    scale = rect.size.width / pageRect.size.width
    CGContextTranslateCTM context, 0, (rect.size.height - pageRect.size.height * scale) / 2    
    CGContextScaleCTM context, scale, scale
    CGContextTranslateCTM context, -pageRect.origin.x, -pageRect.origin.y  

    CGContextDrawPDFPage context, @page
  end

end