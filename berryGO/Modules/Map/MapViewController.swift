//
//  MapViewController.swift
//  berryGO
//
//  Created by Evgeny Gusev on 12.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel
import Geofirestore
import Firebase

protocol MapViewControllerDelegate: AnyObject {
    func fruitsWereDisplayed(_ fruits: [FruitViewModel])
    func cityWasDisplayed(_ cityName: String?)
}

class MapViewController: UIViewController, Storyboarded {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var searchInThisAreaButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchField: UIImageView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchText: UITextField!
  
    let locationManager = CLLocationManager()
    weak var delegate: MapViewControllerDelegate? {
        didSet {
            delegate?.cityWasDisplayed(city)
        }
    }
    var floatingPanelController: FloatingPanelController!
    var regionQuery: GFSRegionQuery?
    var fruits = [FruitViewModel]()
    var shops = [Shop]()
    var city: String?
    var locationWasShowed = false
    var search_txt = ""
    var myNewView: UIView?
    
  
    enum CardState {
           case collapsed
           case expanded
    }
       
    // Variable determines the next state of the card expressing that the card starts and collapased
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
  
    // Variable for effects visual effect view
    var visualEffectView:UIVisualEffectView!
    
    // Starting and end card heights will be determined later
    var endCardHeight:CGFloat = 0
    var startCardHeight:CGFloat = 0
    
    // Current visible state of the card
    var cardVisible = false
    
    // Empty property animator array
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(ShopClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        mapView.userLocation.title = ""
        mapView.tintColor = UIColor.red
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = 200
        
        postButton.layer.cornerRadius = 24
        
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        let contentVC = BerryListViewController.instantiate(fromStoryboard: "Main")
        floatingPanelController.set(contentViewController: contentVC)
        floatingPanelController.track(scrollView: contentVC.tableView)
        floatingPanelController.contentInsetAdjustmentBehavior = .always
        delegate = contentVC
        floatingPanelController.addPanel(toParent: self, belowView: postButton)
        floatingPanelController.surfaceView.layer.cornerRadius = 20
        floatingPanelController.surfaceView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        floatingPanelController.surfaceView.layer.masksToBounds = true
        floatingPanelController.view.backgroundColor = .clear
        clearButton.isHidden = true
      
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.handleModalDismissed),
        name: NSNotification.Name(rawValue: "modalIsDimissed"),
        object: nil)
      
    }
    @objc func handleModalDismissed() {
        self.view.endEditing(true)
        floatingPanelController.move(to: .half, animated: true)
        self.mapView.selectedAnnotations.removeAll()
        self.updateUnselectedAnnotationsSize()
    }
    private func showUserRegion() {
        guard let location = locationManager.location else {
            return
        }
        
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(viewRegion, animated: false)
    }
    
  @IBAction func profileClicked(_ sender: Any) {
      UserManager.openProfileScreen()
  }
  @IBAction func clearClicked(_ sender: Any) {
      self.searchText.text = ""
      clearButton.isHidden = true
      self.view.endEditing(true)
  }
  @IBAction func searchTextChanged(_ sender: Any) {
      self.search_txt = self.searchText.text ?? ""
      if self.search_txt == ""{
          clearButton.isHidden = true
      } else{
          clearButton.isHidden = false
      }
  }
  private func updateVisibleAnnotations() {
        if mapView.selectedAnnotations.count > 0 {
            guard let selectedAnnotation = mapView.selectedAnnotations.first as? ShopAnnotation else {
                return
            }
            self.view.endEditing(true)
            let selectedAnnotationView = mapView.view(for: selectedAnnotation) as! ShopAnnotationView
            if let shop = shops.first(where: { $0.id == selectedAnnotation.id }) {
                if let contentVC = floatingPanelController.contentViewController {
                    if let shopListVC = contentVC as? ShopListViewController {
                        if shopListVC.shop != shop {
                            shopListVC.shop = shop
                        }
                        return
                    }
                    
                    let shopListVC = ShopListViewController.instantiate(fromStoryboard: "Main")
                    shopListVC.shop = shop
                    selectedAnnotationView.imageView.image = shop.getSelectedImage()
                    floatingPanelController.move(to: .tip, animated: true)
//                    floatingPanelController.set(contentViewController: shopListVC)
//                    floatingPanelController.track(scrollView: shopListVC.tableView)
//                    floatingPanelController.contentInsetAdjustmentBehavior = .never
//                    floatingPanelController.surfaceView.grabberHandle.isHidden = false
                    
                    
                    guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                        return
                    }
                    let nc = UINavigationController(rootViewController: shopListVC)
                    nc.navigationBar.isHidden = true
                    nc.modalPresentationStyle = .overCurrentContext
                    navigationController.present(nc, animated: true)
                }
            } else if let fruit = fruits.first(where: { $0.id == selectedAnnotation.id }) {
                if let contentVC = floatingPanelController.contentViewController {
                    if let singleFruitVC = contentVC as? SingleFruitViewController {
                        if singleFruitVC.fruit != fruit {
                            singleFruitVC.fruit = fruit
                        }
                        return
                    }
                    
                    let singleFruitVC = SingleFruitViewController.instantiate(fromStoryboard: "Main")
                    singleFruitVC.fruit = fruit
                    selectedAnnotationView.imageView.image = fruit.getSelectedImage()
                  
/*
                    floatingPanelController.set(contentViewController: singleFruitVC)
                    floatingPanelController.track(scrollView: singleFruitVC.tableView)
                    floatingPanelController.contentInsetAdjustmentBehavior = .never
                    floatingPanelController.surfaceView.grabberHandle.isHidden = true
*/
                    floatingPanelController.move(to: .tip, animated: true)
                    
                    guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
                        return
                    }
                    let nc = UINavigationController(rootViewController: singleFruitVC)
                    nc.navigationBar.isHidden = true
                    nc.modalPresentationStyle = .overCurrentContext
                    navigationController.present(nc, animated: true)
                }
            }
        } else {
            var visibleFruits = fruits.filter { mapView.visibleMapRect.contains(MKMapPoint($0.location.coordinate)) }
            let fruitsFromShops = shops
                .filter { mapView.visibleMapRect.contains(MKMapPoint($0.location.coordinate)) }
                .flatMap { $0.fruits }
            visibleFruits.append(contentsOf: fruitsFromShops)
            visibleFruits.sort(by: { $0.getDistance() < $1.getDistance() } )
            
            updateUnselectedAnnotationsSize()
            if let fruitListVC = floatingPanelController.contentViewController as? BerryListViewController {
                fruitListVC.fruitsWereDisplayed(visibleFruits)
                return
            }
            
            let contentVC = BerryListViewController.instantiate(fromStoryboard: "Main")
            floatingPanelController.set(contentViewController: contentVC)
            floatingPanelController.track(scrollView: contentVC.tableView)
            floatingPanelController.contentInsetAdjustmentBehavior = .never
            floatingPanelController.surfaceView.grabberHandle.isHidden = false
            delegate = contentVC
            delegate?.fruitsWereDisplayed(visibleFruits)
        }
    }
    
    private func updateUnselectedAnnotationsSize() {
        self.view.endEditing(true)
        let berryAnnotations = mapView.annotations(in: mapView.visibleMapRect).filter{ $0 is ShopAnnotation } as! Set<ShopAnnotation>
        let selectedAnnotation = mapView.selectedAnnotations.first as? ShopAnnotation
        berryAnnotations.forEach { annotation in
            guard annotation != selectedAnnotation else {
                return
            }
            guard let annotationView = mapView.view(for: annotation) as? ShopAnnotationView else {
                return
            }
       
            if let shop = shops.first(where: { $0.id == annotation.id }) {
                annotationView.imageView.image = shop.getPinImage()
            } else if let fruit = fruits.first(where: { $0.id == annotation.id }) {
                annotationView.imageView.image = fruit.getPinImage()
            }
        
        }
    }
    
    @IBAction func searchInThisAreaPressed(_ sender: Any) {
        guard let location = locationManager.location else {
            return
        }
        
        searchInThisAreaButton.isHidden = true
        let mapCenterLocation = CLLocation(latitude: mapView.centerCoordinate.latitude,
                                           longitude: mapView.centerCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(mapCenterLocation) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            
            DispatchQueue.main.async {
                self.city = placemark.locality
                self.delegate?.cityWasDisplayed(self.city)
            }
        }
        
        let firestoreFruitsRef = Firestore.firestore().collection("fruits")
        let geoFirestore = GeoFirestore(collectionRef: firestoreFruitsRef)
        regionQuery?.removeAllObservers()
        regionQuery = geoFirestore.query(inRegion: mapView.region)
        let _ = regionQuery?.observe(.documentEntered) { (key, _) in
            guard let key = key,
                !self.fruits.contains(where: { $0.id == key }),
                !self.shops.flatMap({ $0.fruits }).contains(where: { $0.id == key }) else {
                return
            }
            firestoreFruitsRef.document(key).getDocument { (document, error) in
                guard error == nil, let document = document,
                    !self.fruits.contains(where: { $0.id == key }),
                    !self.shops.flatMap({ $0.fruits }).contains(where: { $0.id == key }) else {
                    return
                }
                
                if let fruitVM = FruitViewModel(document.data(), id: document.documentID, location: location) {
                    DataManager.loadPhotos(for: document.documentID)
                    if fruitVM.shopId != nil {
                        guard let shop = Shop(fruitVM, location: location) else {
                            return
                        }
                        if let index = self.shops.firstIndex(of: shop) {
                            self.shops[index].fruits.append(fruitVM)
                        } else {
                            self.shops.append(shop)
                            self.mapView.addAnnotation(ShopAnnotation(coordinate: shop.location.coordinate, id: shop.id, image: shop.getPinImage()))
                        }
                    } else {
                        self.fruits.append(fruitVM)
                        self.mapView.addAnnotation(ShopAnnotation(coordinate: fruitVM.location.coordinate, id: fruitVM.id, image: fruitVM.getPinImage()))
                    }
                    self.updateVisibleAnnotations()
                }
            }
        }
    
        updateVisibleAnnotations()
    }
    
    @IBAction func postPressed(_ sender: Any) {
        let newFruitVC = NewFruitViewController.instantiate(fromStoryboard: "NewFruit")
        navigationController?.pushViewController(newFruitVC, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        showUserRegion()
        searchInThisAreaPressed(self)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locationWasShowed else {
            return
        }
        locationWasShowed.toggle()
        showUserRegion()
        searchInThisAreaPressed(self)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is ShopAnnotation {
            let shopAnnotationView = ShopAnnotationView(annotation: annotation, reuseIdentifier: "ShopAnnotationView")
            return shopAnnotationView
        } else if annotation is MKClusterAnnotation {
            return ShopClusterAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is ShopAnnotationView else {
            return
        }
        updateVisibleAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        updateVisibleAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        searchInThisAreaButton.isHidden = false
        updateVisibleAnnotations()
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return ExpandableBottomSheetLayout()
    }
    
    func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
        searchInThisAreaButton.isHidden = true
        if vc.position == .half {
            vc.contentViewController?.view.endEditing(true)
        }
    }
    
    func floatingPanelShouldBeginDragging(_ vc: FloatingPanelController) -> Bool {
        !floatingPanelController.surfaceView.grabberHandle.isHidden
    }
}

class ExpandableBottomSheetLayout: FloatingPanelLayout {
  var initialPosition: FloatingPanelPosition = .half
  var supportedPositions: Set<FloatingPanelPosition> = [.full, .half, .tip]
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .half:
            return 285
        case .full:
            return 0
        case .tip:
            return 40
        default:
            return nil
        }
    }
}
public extension UIImage {

    /**
    Returns the flat colorized version of the image, or self when something was wrong

    - Parameters:
        - color: The colors to user. By defaut, uses the ``UIColor.white`

    - Returns: the flat colorized version of the image, or the self if something was wrong
    */
    func colorized(with color: UIColor = .white) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }


        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        color.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.clip(to: rect, mask: cgImage)
        context.fill(rect)

        guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }

        return colored
    }

    /**
    Returns the stroked version of the fransparent image with the given stroke color and the thickness.

    - Parameters:
        - color: The colors to user. By defaut, uses the ``UIColor.white`
        - thickness: the thickness of the border. Default to `2`
        - quality: The number of degrees (out of 360): the smaller the best, but the slower. Defaults to `10`.

    - Returns: the stroked version of the image, or self if something was wrong
    */

  func stroked(with color: UIColor = .red, thickness: CGFloat = 1.2, quality: CGFloat = 2) -> UIImage {

        guard let cgImage = cgImage else { return self }

        // Colorize the stroke image to reflect border color
        let strokeImage = colorized(with: color)

        guard let strokeCGImage = strokeImage.cgImage else { return self }

        /// Rendering quality of the stroke
        let step = quality == 0 ? 10 : abs(quality)

        let oldRect = CGRect(x: thickness, y: thickness, width: size.width, height: size.height).integral
        let newSize = CGSize(width: size.width + 2 + 2 * thickness, height: size.height + 2 + 2 * thickness)
        let translationVector = CGPoint(x: thickness, y: 0)


        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)

        guard let context = UIGraphicsGetCurrentContext() else { return self }

        defer {
            UIGraphicsEndImageContext()
        }
        context.translateBy(x: 0, y: newSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.interpolationQuality = .high

        for angle: CGFloat in stride(from: 0, to: 360, by: step) {
            let vector = translationVector.rotated(around: .zero, byDegrees: angle)
            let transform = CGAffineTransform(translationX: vector.x, y: vector.y)

            context.concatenate(transform)

            context.draw(strokeCGImage, in: oldRect)

            let resetTransform = CGAffineTransform(translationX: -vector.x, y: -vector.y)
            context.concatenate(resetTransform)
        }

        context.draw(cgImage, in: oldRect)

        guard let stroked = UIGraphicsGetImageFromCurrentImageContext() else { return self }

        return stroked
    }
}


extension CGPoint {
    /**
    Rotates the point from the center `origin` by `byDegrees` degrees along the Z axis.

    - Parameters:
        - origin: The center of he rotation;
        - byDegrees: Amount of degrees to rotate around the Z axis.

    - Returns: The rotated point.
    */
    func rotated(around origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
        let dx = x - origin.x
        let dy = y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + byDegrees * .pi / 180.0 // to radians
        let x = origin.x + radius * cos(newAzimuth)
        let y = origin.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
    }
}
