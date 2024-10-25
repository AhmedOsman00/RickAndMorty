struct FilterUiModel: Hashable {
    let status: Status
    let isSelected: Bool
}

extension FilterUiModel {
    init(_ status: Status) {
        self.status = status
        isSelected = false
    }
}
