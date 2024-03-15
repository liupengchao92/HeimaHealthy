import { CommonConstants } from '../common/constants/CommonConstants'
import router from '@ohos.router'
import ItemList from '../view/item/ItemList'
import ItemPanelHeader from '../view/item/ItemPanelHeader'
import ItemCard from '../view/item/ItemCard'

@Entry
@Component
struct ItemIndex {
  @State showPanel: boolean = false
  @State amount: number = 0

  onPanelShow() {
    this.showPanel = true
  }

  build() {
    Column() {
      //1.头部导航
      this.header()
      //2.列表
      ItemList({ showPanel: this.onPanelShow.bind(this) }).layoutWeight(1)
      //3.底部面板
      Panel(this.showPanel) {
        //3.1顶部日期
        ItemPanelHeader()
        //3.1食物信息卡片
        ItemCard({amount:this.amount})
        //3.3数字键盘
        //3.4按钮

      }.mode(PanelMode.Full)
      .dragBar(false)
      .backgroundMask($r('app.color.light_gray'))
      .backgroundColor(Color.White)

    }
    .width('100%')
    .height('100%')
  }

  @Builder header() {
    Row() {
      Image($r('app.media.ic_public_back'))
        .width(24)
        .onClick(() => router.back())
      Blank()
      Text('早餐').fontSize(18).fontWeight(CommonConstants.FONT_WEIGHT_600)
    }
    .width(CommonConstants.THOUSANDTH_940)
    .height(32)
  }
}