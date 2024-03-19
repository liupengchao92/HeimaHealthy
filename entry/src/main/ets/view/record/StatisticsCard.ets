import { CommonConstants } from '../../common/constants/CommonConstants'
import DateUtil from '../../common/utils/DateUtil'
import DatePickerDialog from '../record/DatePickerDialog'
import CaloriesStats from '../record/CaloriesStats'
import NutrientStats from './NutrientStats'
import RecordVO from '../../common/bean/RecordVO'
import StatsInfo from '../../viewmodel/StatsInfo'
import RecordService from '../../service/RecordService'

@Component
export default struct StatisticCard {
  // 获取选中的日期
  @StorageProp('selectedDate') selectedDate: number = DateUtil.beginTimeOfDay(new Date())
  // 记录数据
  @Consume
  @Watch('handleRecordsChange')
  records: RecordVO[]
  // 统计信息
  @State info: StatsInfo = new StatsInfo()

  handleRecordsChange() {
    // 计算统计信息
    this.info = RecordService.calculateStatsInfo(this.records)
  }

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

      Swiper() {
        //2.1热量统计
        CaloriesStats({ intake: this.info.intake, expend: this.info.expend })
        //2.2 营养消耗
        NutrientStats({ carbon: this.info.carbon, protein: this.info.protein, fat: this.info.fat })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(CommonConstants.DEFAULT_18)
      .indicatorStyle({ selectedColor: $r('app.color.primary_color') })
    }
    .width(CommonConstants.THOUSANDTH_940)
    .backgroundColor($r('app.color.stats_title_bgc'))
    .borderRadius(CommonConstants.DEFAULT_18)
  }
}