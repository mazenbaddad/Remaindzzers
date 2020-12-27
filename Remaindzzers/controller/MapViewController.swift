//
//  MapViewController.swift
//  Remaindzzers
//
//  Created by mazen baddad on 11/8/20.
//  Copyright © 2020 mazen baddad. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

protocol MapViewControllerDelegate : class {
    func mapViewControllerDidUpdateRemainders()
}

class MapViewController : UIViewController {
    
    weak var delegate : MapViewControllerDelegate?
    
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var categories : Array<CustomCategory> = []
    var annotations : Array<MKPointAnnotation> = []
    
    var selectedAnnotation : MKAnnotationView?
    var selectedLocation : CLLocationCoordinate2D?
    
    var addCategoryMode : Bool = true
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var deleteCategoryButton : UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("Delete", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchCustomCategories()
        zoomToUserLocation()
    }
    
    func setupViews() {
        self.view = mapView
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        self.view.addSubview(backButton)
        self.view.addSubview(deleteCategoryButton)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.setConstraints(view.leadingAnchor, 15, view.topAnchor, 15)
        
        deleteCategoryButton.addTarget(self, action: #selector(deleteCategory), for: .touchUpInside)
        deleteCategoryButton.setConstraints(view.leadingAnchor, 0, nil, 40 , view.trailingAnchor , 0 , view.bottomAnchor , 0)
        
    }
    
    func zoomToUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func fetchCustomCategories() {
        do {
            let categories = try context.fetch(CustomCategory.fetchRequest()) as [CustomCategory]
            self.categories = categories
            self.mapView.removeAnnotations(self.annotations)
            for category in categories {
                let annotaion = MKPointAnnotation()
                annotaion.coordinate = CLLocationCoordinate2D(latitude: category.latitude, longitude: category.longitude)
                annotaion.title = category.title
                annotaion.subtitle = category.subtitile
                self.annotations.append(annotaion)
                self.mapView.addAnnotation(annotaion)
            }
        }catch {
            print(error)
        }
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            self.selectedLocation = coordinate
            let alertView = AlertView()
            alertView.topTitleLabel.text = "Pin info"
            alertView.titleLabel.text = "Title"
            alertView.descriptionLabel.text = "Subtitle"
            alertView.delegate = self
            alertView.present()
        }
    }
    
    @objc func deleteCategory() {
        if let selectedAnnotation = self.selectedAnnotation {
            if let customCategory = self.categories.filter({$0.title == selectedAnnotation.annotation?.title
                && $0.subtitile == selectedAnnotation.annotation?.subtitle
                && $0.latitude == selectedAnnotation.annotation?.coordinate.latitude
                && $0.longitude == selectedAnnotation.annotation?.coordinate.longitude}).first {
                
                let location = CLLocationCoordinate2D(latitude: customCategory.latitude, longitude: customCategory.longitude)
                
                /// delete all remainder associated with this location
                do {
                    let remainders = try context.fetch(Remainder.fetchRequest()) as Array<Remainder>
                    for remainder in remainders where remainder.latitude == location.latitude && remainder.longitude == location.longitude{
                        context.delete(remainder)
                    }
                }catch {
                    print(error)
                }
                
                // stop monitoring for the custom location
                if let id = customCategory.id {
                    print(id)
                    let region = CLCircularRegion(center: location, radius: 10, identifier: id)
                    region.notifyOnExit = false
                    CLLocationManager().stopMonitoring(for: region)
                }
                
                // delete the custom location
                context.delete(customCategory)
                do {
                    // save changes and refetch the categories
                    try context.save()
                    self.fetchCustomCategories()
                    self.delegate?.mapViewControllerDidUpdateRemainders()
                }catch {
                    print(error)
                }
            }
            
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true)
    }
    
    deinit {
        print("map deinit")
    }
}

//MARK: - MapView Delegate

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotation = view
        deleteCategoryButton.isUserInteractionEnabled = true
        deleteCategoryButton.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.selectedAnnotation = nil
        deleteCategoryButton.isUserInteractionEnabled = false
        deleteCategoryButton.isHidden = true
    }
    
    
}

//MARK: - AlertView Delegate

extension MapViewController : AlertViewDelegate {
    
    func alertView(_ alertView: AlertView, didAdd alertInfo: Dictionary<String, Any>) {
        guard let location = self.selectedLocation else {return}
        let customCategory = CustomCategory(context: context)
        let uid = ("\(5)\(NSUUID().uuidString)")
        customCategory.title = alertInfo[alertView.titleAlertKey] as? String
        customCategory.subtitile = alertInfo[alertView.descriptionAlertKey] as? String
        customCategory.latitude = location.latitude
        customCategory.longitude = location.longitude
        customCategory.id = uid
        
        print("location: latitude \(location.latitude), longitude \(location.longitude) for :" , customCategory.title!)
        do {
            try context.save()
            self.fetchCustomCategories()
            let region = CLCircularRegion(center: location, radius: 10, identifier: uid)
            region.notifyOnExit = false
            CLLocationManager().startMonitoring(for: region)
        }catch {
            print(error)
        }
        alertView.removeFromSuperview()
    }
}

extension MapViewController : UIGestureRecognizerDelegate {
    
}
