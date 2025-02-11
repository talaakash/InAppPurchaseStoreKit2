import UIKit

class PlanCell: UITableViewCell {

    @IBOutlet weak var planTitle: UILabel!
    @IBOutlet weak var planDescription: UILabel!
    @IBOutlet weak var planPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
