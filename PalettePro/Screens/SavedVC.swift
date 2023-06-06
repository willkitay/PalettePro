//
//  SavedVC.swift
//  PalettePro
//
//  Created by Will Kitay on 5/28/23.
//

import UIKit

class SavedVC: UIViewController {
  
  let savedPalettesVC = SavedPalettesVC()
  let savedColorsVC = SavedColorsVC()
  let segmentedControl = UISegmentedControl()
  
  private var pageViewController: UIPageViewController!
  private var viewControllers: [UIViewController] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureBottomBar()
    configurePageViewController()
  }
  
  func configure() {
    view.backgroundColor = .systemBackground
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  private func configureBottomBar() {
    let bottomBarContainer = UIView()
    bottomBarContainer.backgroundColor = .systemGray6
    bottomBarContainer.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bottomBarContainer)
    
    NSLayoutConstraint.activate([
      bottomBarContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1),
      bottomBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomBarContainer.heightAnchor.constraint(equalToConstant: 50)
    ])
    
    bottomBarContainer.addSubview(segmentedControl)
    configureSegmentedController()
    segmentedControl.pinToEdges(of: bottomBarContainer)
  }
  
  private func configureSegmentedController() {
    segmentedControl.backgroundColor = .systemBackground
    segmentedControl.insertSegment(withTitle: "Colors", at: 0, animated: false)
    segmentedControl.insertSegment(withTitle: "Palettes", at: 1, animated: false)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func configurePageViewController() {
    pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    pageViewController.dataSource = self
    view.addSubview(pageViewController.view)
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pageViewController.view.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor)
    ])
    
    let colorsNavigationController = UINavigationController(rootViewController: savedColorsVC)
    let palettesNavigationController = UINavigationController(rootViewController: savedPalettesVC)
    
    viewControllers = [colorsNavigationController, palettesNavigationController]
    pageViewController.setViewControllers([colorsNavigationController], direction: .forward, animated: false, completion: nil)
    pageViewController.delegate = self
  }
  
  @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    let selectedIndex = sender.selectedSegmentIndex
    
    if selectedIndex == 0 {
      pageViewController.setViewControllers([viewControllers[0]], direction: .reverse, animated: true, completion: nil)
    } else if selectedIndex == 1 {
      pageViewController.setViewControllers([viewControllers[1]], direction: .forward, animated: true, completion: nil)
    }
  }
  
}

extension SavedVC: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
    let previousIndex = currentIndex - 1
    guard previousIndex >= 0 && previousIndex < viewControllers.count else { return nil }
    return viewControllers[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = viewControllers.firstIndex(of: viewController) else { return nil }
    let nextIndex = currentIndex + 1
    guard nextIndex >= 0 && nextIndex < viewControllers.count else { return nil }
    return viewControllers[nextIndex]
  }
  
}

extension SavedVC: UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed, let currentViewController = pageViewController.viewControllers?.first,
       let currentIndex = viewControllers.firstIndex(of: currentViewController) {
      segmentedControl.selectedSegmentIndex = currentIndex
    }
  }
  
}
