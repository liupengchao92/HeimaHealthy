
import { CommonConstants } from '../../common/constants/CommonConstants'
@Component
struct CaloriesStats{

  build(){
    Row({space:CommonConstants.SPACE_6}){

      Column(){
        Text('饮食摄入')
        Text('190')
      }

      Column(){
        Text('饮食摄入')
        Text('190')
      }

    }.width('100%')
  }

}