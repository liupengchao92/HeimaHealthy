import SearchHeader from '../record/SearchHeader'
import StatisticsCard from '../record/StatisticsCard'
import RecordList from './RecordList'

@Component
export default struct RecordIndex {
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