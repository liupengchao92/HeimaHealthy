import { CommonConstants } from '../common/constants/CommonConstants'
import router from '@ohos.router'
import ItemList from '../view/item/ItemList'
import ItemPanelHeader from '../view/item/ItemPanelHeader'
import ItemCard from '../view/item/ItemCard'
import NumberKeyboard from '../view/item/NumerKeyboard'
import RecordItem from '../viewmodel/RecordItem'
import RecordType from '../viewmodel/RecordType'
import { RecordTypeEnum, recordTypes } from '../viewmodel/RecordTypeModel'
import RecordService from '../service/RecordService'

@Entry
@Component
struct ItemIndex {
  @State showPanel: boolean = false
  @State amount: number = 1
  @State value: string = ''
  @State item: RecordItem = null
  @State type: RecordType = recordTypes[0]
  @State isFood: boolean = true

  onPanelShow(item: RecordItem) {
    this.value = ''
    this.item = item
    this.showPanel = true
  }

  onPageShow() {
    // 获取传递的参数
    let params: any = router.getParams()
    // 获取饮食记录的类型
    this.type = params.type
    // 是否是食物
    this.isFood = this.type.id !== RecordTypeEnum.WORKOUT
  }

  build() {
    Column() {
      //1.头部导航
      this.header()
      //2.列表
      ItemList({ showPanel: this.onPanelShow.bind(this), isFood: this.isFood }).layoutWeight(1)
      //3.底部面板
      Panel(this.showPanel) {
        //3.1顶部日期
        ItemPanelHeader()
        //3.1食物信息卡片
        if (this.item) {
          ItemCard({ amount: this.amount, item: $item })
        }
        //3.3数字键盘
        NumberKeyboard({ amount: $amount, value: $value })
        //3.4按钮
        Row({ space: CommonConstants.SPACE_6 }) {
          Button('取消')
            .width(120)
            .backgroundColor($r('app.color.light_gray'))
            .type(ButtonType.Normal)
            .borderRadius(6)
            .onClick(() => this.showPanel = false)

          Button('提交')
            .width(120)
            .backgroundColor($r('app.color.primary_color'))
            .type(ButtonType.Normal)
            .borderRadius(6)
            .onClick(() => {
              //1.持久化存储
              RecordService.insert(this.type.id, this.item.id, this.amount)
                .then(() => {
                  // 关闭弹出
                  this.showPanel = false
                })
            })
        }
        .margin({ top: 10 })
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
      Text(this.type.name).fontSize(18).fontWeight(CommonConstants.FONT_WEIGHT_600)
    }
    .width(CommonConstants.THOUSANDTH_940)
    .height(32)
    .margin({ top: 10 })
  }
}