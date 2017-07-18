//
//  ViewController.swift
//  MapTest
//
//  Created by JHH on 2017. 7. 11..
//  Copyright © 2017년 JHH. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces






class ViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var coordinate: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var locationCountLabel: UILabel!
    var locationManager = CLLocationManager()
    var mapView:GMSMapView!
    var marker = GMSMarker()
    
    var count = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame:mainView.frame ,camera:camera)

        adjustMapStyle()
        addOverlay()
        
        mainView.addSubview(mapView)
        self.mapView.isMyLocationEnabled = true

        self.locationManager.delegate = self
        self.locationManager.startMonitoringSignificantLocationChanges() //백그라운드에서 기지국이 바뀔 때만 노티 받음.
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
//        self.locationManager.allowsBackgroundLocationUpdates = true

        marker.title = "me!"
        marker.snippet = "Australia"
        marker.icon = UIImage(named: "spidey")
        marker.iconView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        marker.map = mapView
        
        
        let path = GMSMutablePath()
        path.addLatitude(-37.81319, longitude: 144.96298)
        path.addLatitude(-31.95285, longitude: 115.85734)
        let polyLine = GMSPolyline(path: path)
        polyLine.map = mapView
        polyLine.strokeColor = .blue
        polyLine.geodesic = true
        
        
        
    }

    //locationManager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        let long = location?.coordinate.longitude
        let lat = location?.coordinate.latitude
        let speed = location?.speed
        
        count += 1
        locationCountLabel.text = "\(String(count))"
        
//        self.mapView.animate(to: camera)

        marker.position = (location?.coordinate)!
        
        coordinate.text = "위치 : \(long!), \(lat!)"
        statusLabel.text = "speed : \(speed!)"
        print("위도 : \(long!) , 경도 : \(lat!)")

        previewImage.image = searchArea(lat: Float(long!), long: Float(lat!))
//        self.locationManager.stopUpdatingLocation()
    }
    
    func adjustMapStyle(){
        do {
            if let styleURL = Bundle.main.url(forResource: "grayStyle", withExtension: "json"){
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL : styleURL)
            }else{
                print("unable to find style.json")
            }
        }catch{
            print ("failed to load map style")
        }
    }
    
    
    func addOverlay(){
        let marker1 = GMSMarker()
        marker1.title = "one"
        marker1.map = mapView
        marker1.position = CLLocationCoordinate2D(latitude: 40.712216, longitude: -74.22655)
        
        let marker2 = GMSMarker()
        marker2.title = "two"
        marker2.map = mapView
        marker2.position = CLLocationCoordinate2D(latitude: 40.773941, longitude: -74.12544)
        
        let southWest = CLLocationCoordinate2D(latitude: 40.712216, longitude: -74.22655)
        let northEast = CLLocationCoordinate2D(latitude: 40.773941, longitude: -74.12544)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        
        
        
        let icon = UIImage(named:"newark")

        let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: icon)
        overlay.map = mapView
        

        
    }
    
    func searchArea(lat : Float , long : Float)->UIImage{
        let staticMapURL = NSString(format: "http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&%@&sensor=true", lat,long,"zoom=10&size=270x70")
        let mapURL = URL(string: staticMapURL.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
        do {
            return try UIImage(data: NSData(contentsOf: mapURL!) as Data)!
        } catch  {
            return UIImage()
        }
    }
//    func addTile(){
//        let floor = 1
//        
//        // Implement GMSTileURLConstructor
//        // Returns a Tile based on the x,y,zoom coordinates, and the requested floor
//        let urls: GMSTileURLConstructor = {(x, y, zoom) in
//            let url = "https://www.example.com/floorplans/L\(floor)_\(zoom)_\(x)_\(y).png"
//            return URL(string: url)
//        }
//        
//        // Create the GMSTileLayer
//        let layer = GMSURLTileLayer(urlConstructor: urls)
//        
//        // Display on the map at a specific zIndex
//        layer.zIndex = 100
//        layer.map = mapView
//    }
    
    
}



    

