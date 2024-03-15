import { CommonConstants } from '../common/constants/CommonConstants'
import router from '@ohos.router'
import ItemList from '../view/item/ItemList'

@Entry
@Component
struct ItemIndex {
  build() {
    Column() {
      //1.头部导航
      this.header()
      //2.列表
      ItemList()

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