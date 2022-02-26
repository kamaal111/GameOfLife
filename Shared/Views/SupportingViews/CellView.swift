//
//  CellView.swift
//  GameOfLife
//
//  Created by Kamaal M Farah on 26/02/2022.
//

import SwiftUI

struct CellView: View {
    let cell: Universe.Cell
    let size: CGSize

    var body: some View {
        cell.color
            .frame(width: size.width, height: size.height)
    }
}

#if DEBUG
import ShrimpExtensions

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: .alive, size: .squared(4))
    }
}
#endif
