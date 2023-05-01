import UIKit
import RealmSwift

// schemaVersion: 1
//class TestObject: Object {
//    @Persisted(primaryKey: true) var id: String
//}

class TestObject: Object {
    @Persisted(primaryKey: true) var id: String

    @Persisted var testString: String
    @Persisted var testDate: Date
    @Persisted var testEnum: TestEnum
}

enum TestEnum: String, CaseIterable, PersistableEnum {
    case foo
    case bar
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        copyBundledRealm()

        let realm = try! Realm(
            configuration: Realm.Configuration(
                schemaVersion: 2
            )
        )

        // Used to write one object in schemaVersion 1.
//        try! realm.write {
//            let object = TestObject()
//            object.id = UUID().uuidString
//            realm.add(object)
//        }

        let testObject = realm.objects(TestObject.self).first
        assert(testObject != nil)

        _ = testObject?.testString // works fine
        _ = testObject?.testDate // works fine
        _ = testObject?.testEnum // crashes
    }

    private func copyBundledRealm() {
        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        let bundleURL = Bundle.main.url(forResource: "default", withExtension: "realm")!
        try? FileManager.default.removeItem(at: defaultURL)
        try! FileManager.default.copyItem(at: bundleURL, to: defaultURL)
    }
}
