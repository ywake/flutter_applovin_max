import UIKit
import AppLovinSDK

class BannerAdController: UIViewController, MAAdViewAdDelegate, MAAdRevenueDelegate
{
    private var adView: MAAdView? = nil

    var types = [
        "BANNER" : MAAdFormat.banner,
        "LEADER" :  MAAdFormat.leader,
        "MREC" : MAAdFormat.mrec
    ]
    var type: String?

    func initBannerAdController(unitId: String, sizeType: String)
    {
        type = sizeType
        adView = MAAdView(adUnitIdentifier: unitId, adFormat: types[type!]!)
        adView?.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let height: CGFloat =  types[type!]!.adaptiveSize.height

        if let adView = adView {
            adView.delegate = self
            adView.revenueDelegate = self
            view.addSubview(adView)
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: view.topAnchor),
                adView.leftAnchor.constraint(equalTo: view.leftAnchor),
                adView.rightAnchor.constraint(equalTo: view.rightAnchor),
                adView.heightAnchor.constraint(equalToConstant: height),

            ])
            adView.loadAd()
        }
    }

    // MARK: MAAdDelegate Protocol
    
    func didLoad(_ ad: MAAd) {
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {}

    func didDisplay(_ ad: MAAd) {
    }

    func didHide(_ ad: MAAd) {  }

    func didClick(_ ad: MAAd) {
        globalMethodChannel?.invokeMethod("AdClicked", arguments: nil)
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {  }

    // MARK: MAAdViewAdDelegate Protocol
    
    func didExpand(_ ad: MAAd) {  }

    func didCollapse(_ ad: MAAd) {  }

    // MARK: MAAdRevenueDelegate Protocol
    
    func didPayRevenue(for ad: MAAd) {  }
}
