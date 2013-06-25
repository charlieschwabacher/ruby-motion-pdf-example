class PDFViewController < UIViewController

  def loadView
    self.view = UIView.alloc.initWithFrame CGRectZero
  end

  def viewDidLoad
    super

    @pageViewController = UIPageViewController.alloc.initWithTransitionStyle(
      UIPageViewControllerTransitionStylePageCurl,
      navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal,
      options: nil
    )

    @pageViewController.delegate = PDFViewDelegate.new
    @pageViewController.dataSource = PDFViewDataSource.new

    @pageViewController.view.frame = view.frame
    view.addSubview @pageViewController.view

    @pageViewController.setViewControllers(
      [@pageViewController.dataSource.currentPageViewController],
      direction: UIPageViewControllerNavigationDirectionForward,
      animated: false,
      completion: lambda {|a|}
    )

    # somehow this prevents a crash
    @pageViewController.dataSource.method(:'pageViewController:viewControllerAfterViewController')
    @pageViewController.dataSource.method(:'pageViewController:viewControllerBeforeViewController')
  end

end


class PDFViewDataSource # UIPageViewControllerDataSource

  def initialize
    @url = NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource('and_picasso_painted_guernica', ofType: 'pdf'))
    @document = CGPDFDocumentCreateWithURL @url
    @pageCount = CGPDFDocumentGetNumberOfPages @document
    @currentPage = 1
  end

  def pageViewController(controller, viewControllerBeforeViewController: viewController)
    return nil if @currentPage == 1
    @currentPage -= 1

    currentPageViewController
  end

  def pageViewController(controller, viewControllerAfterViewController: viewController)
    return nil if @currentPage == @pageCount
    @currentPage += 1

    currentPageViewController
  end

  def currentPageViewController
    page = CGPDFDocumentGetPage @document, @currentPage
    PDFPageViewController.new(page)
  end

end


class PDFViewDelegate # UIPageViewControllerDelegate

  def pageViewController(controller, spineLocationForInterfaceOrientation: orientation)
    UIPageViewControllerSpineLocationMin
  end

  # def pageViewController(controller, willTransitionToViewControllers: viewControllers)
  # end

  # def pageViewController(controller, didFinishAnimating: finished, previousViewControllers: previous, transitionCompleted: completed)
  # end

end

