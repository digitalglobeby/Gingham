// Built by `swift build` of this package, which has nothing else to build:
// both frameworks import, and their types are there. Not part of a product.
import Gingham
import GinghamICU

@MainActor
func ginghamBuildCheck() -> (version: String, collation: any GHCollationKeyProvider) {
    (GHTableView.version, GHBundledICUCollation())
}
