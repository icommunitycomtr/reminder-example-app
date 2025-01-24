//
//  UITableView.swift
//  Reminder
//
//  Created by Mert Ozseven on 20.01.2025.
//

import UIKit

extension UITableView {
    /// Resize table header view to fit its content
    func layoutTableHeaderView() {
        guard let headerView = self.tableHeaderView else { return }

        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerWidth = self.bounds.size.width
        let temporaryWidthConstraint = headerView.widthAnchor.constraint(equalToConstant: headerWidth)
        headerView.addConstraint(temporaryWidthConstraint)

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var headerFrame = headerView.frame
        headerFrame.size.height = headerSize.height
        headerView.frame = headerFrame

        self.tableHeaderView = headerView
        headerView.removeConstraint(temporaryWidthConstraint)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}
