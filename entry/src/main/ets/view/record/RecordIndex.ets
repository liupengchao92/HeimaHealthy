import RecordVO from '../../common/bean/RecordVO'
import DateUtil from '../../common/utils/DateUtil'
import RecordService from '../../service/RecordService'
import SearchHeader from '../record/SearchHeader'
import StatisticsCard from '../record/StatisticsCard'
import RecordList from './RecordList'

@Component
export default struct RecordIndex {
  // 当前日期
  @StorageProp('selectedDate')
  @Watch('aboutToAppear')
  selectedDate: number = DateUtil.beginTimeOfDay(new Date())
  @Provide records: RecordVO[] = []
  @Watch('onPageChange')
  @Prop isPageShow: boolean
  async aboutToAppear() {
    this.records = await  RecordService.queryRecordByDate(this.selectedDate)
  }

  onPageChange() {
    if (this.isPageShow) {
      this.aboutToAppear()
    }
  }

  build() {

    Column() {
      // 1.第一部分：搜索栏
      SearchHeader()
      // 2.统计卡片
      StatisticsCard()
      // 3.记录列表
      RecordList().layoutWeight(1)

    }.width('100%')
    .height('100%')
    .backgroundColor($r('app.color.index_page_background'))
  }
}