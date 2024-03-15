import { CommonConstants } from '../../common/constants/CommonConstants'
import DateUtil from '../../common/utils/DateUtil'
import DatePickerDialog from '../record/DatePickerDialog'
import CaloriesStats from '../record/CaloriesStats'
import NutrientStats from './NutrientStats'

@Component
export default struct StatisticCard {

  // 获取选中的日期
  @StorageProp('selectedDate') selectedDate: number = DateUtil.beginTimeOfDay(new Date())
  controller: CustomDialogController = new CustomDialogController({
    builder: DatePickerDialog({ selectedDate: new Date(this.selectedDate) })
  })

  build() {
    Column() {
      Row() {
        Text(DateUtil.formatDate(this.selectedDate))
          .fontColor($r('app.color.secondary_color'))
        Image($r('app.media.ic_public_spinner'))
          .fillColor($r('app.color.secondary_color'))
          .width(20)
      }
      .padding(CommonConstants.SPACE_8)
      .onClick(() => {
        this.controller.open()
      })

      Swiper(){
        //2.1热量统计
        CaloriesStats()

        //2.2 营养消耗
        NutrientStats()
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(CommonConstants.DEFAULT_18)
      .indicatorStyle({selectedColor:$r('app.color.primary_color')})
    }
    .width(CommonConstants.THOUSANDTH_940)
    .backgroundColor($r('app.color.stats_title_bgc'))
    .borderRadius(CommonConstants.DEFAULT_18)
  }
}