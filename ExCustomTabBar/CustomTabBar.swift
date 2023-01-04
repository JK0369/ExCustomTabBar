//
//  CustomTabBar.swift
//  ExCustomTabBar
//
//  Created by 김종권 on 2023/01/04.
//

import UIKit

enum TabItem: Int {
    case home
    case chat
    case my
    
    var normalImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .chat:
            return UIImage(systemName: "message")
        case .my:
            return UIImage(systemName: "person.crop.circle")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")
        case .chat:
            return UIImage(systemName: "message.fill")
        case .my:
            return UIImage(systemName: "person.crop.circle.fill")
        }
    }
}

final class CustomTabBar: UIView {
    private enum Metric {
        static let tabBarHeight = 56.0
        static let tabBarWidth = UIScreen.main.bounds.width / 3 // tabItem 갯수로 나누기
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    private let tabItems: [TabItem]
    private var tabButtons = [UIButton]()
    private var selectedIndex = 0 {
        didSet { updateUI() }
    }
    
    init(tabItems: [TabItem]) {
        self.tabItems = tabItems
        super.init(frame: .zero)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUp() {
        defer { updateUI() }
        
        tabItems
            .enumerated()
            .forEach { i, item in
                let button = UIButton()
                button.setImage(item.normalImage, for: .normal)
                button.setImage(item.normalImage?.alpha(0.5), for: .highlighted)
                button.addAction { [weak self] in
                    self?.selectedIndex = i
                }
                tabButtons.append(button)
                stackView.addArrangedSubview(button)
            }
        
        backgroundColor = .systemGray.withAlphaComponent(0.2)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    private func updateUI() {
        tabItems
            .enumerated()
            .forEach { i, item in
                let isButtonSelected = selectedIndex == i
                let image = isButtonSelected ? item.selectedImage : item.normalImage
                let selectedButton = tabButtons[i]
                
                selectedButton.setImage(image, for: .normal)
                selectedButton.setImage(image?.alpha(0.5), for: .highlighted)
        }
    }
}

// https://stackoverflow.com/questions/25919472/adding-a-closure-as-target-to-a-uibutton
public extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> ()) {
        @objc class ClosureSleeve: NSObject {
            let closure: () -> ()
            
            init(_ closure: @escaping () -> ()) {
                self.closure = closure
            }
            
            @objc func invoke() {
                closure()
            }
        }
        
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

// https://stackoverflow.com/questions/28517866/how-to-set-the-alpha-of-an-uiimage-in-swift-programmatically
extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
