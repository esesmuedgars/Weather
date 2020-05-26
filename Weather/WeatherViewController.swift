//
// Copyright © 2020 @esesmuedgars.
//

import UIKit
import MapKit

final class WeatherViewController: UIViewController {
    
    @IBOutlet private var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    @IBOutlet private var visualEffectView: UIVisualEffectView! {
        didSet {
            visualEffectView.layer.cornerRadius = 10
        }
    }
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var temperatureLabel: UILabel! {
        didSet {
            temperatureLabel.text = nil
            temperatureLabel.font = .preferredFont(forTextStyle: .headline)
            temperatureLabel.adjustsFontForContentSizeCategory = true
        }
    }
    @IBOutlet private var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = nil
            descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
            descriptionLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    var viewModel: WeatherViewModelType!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.retrieveInitialCoordinate { [unowned self] coordinate in
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            )
            
            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension WeatherViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        mapView.userLocation.title = nil
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        activityIndicator.startAnimating()
        
        viewModel.didUpdateUserLocation(userLocation.coordinate) { [unowned self] weatherForecast in
            self.imageView.image = weatherForecast.icon.image
            self.temperatureLabel.text = weatherForecast.temperature
            self.descriptionLabel.text = weatherForecast.description
            
            self.activityIndicator.stopAnimating()
        }
    }
}
