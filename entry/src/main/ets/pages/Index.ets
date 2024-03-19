import { CommonConstants } from '../common/constants/CommonConstants'
import BeakPointSystem from '../common/utils/BreakPointSystem'
import RecordIndex from '../view/record/RecordIndex'
import BreakpointConstants from '../common/constants/BreakpointConstants'
import BreakpointType from '../common/bean/BreakpointType'

@Entry
@Component
struct Index {
  private breakPointSystem: BeakPointSystem = new BeakPointSystem()
  // 当前角标
  @State currentIndex: number = 0
  // 屏幕大小
  @StorageProp('currentBreakpoint') currentBreakPoint: string = BreakpointConstants.BREAKPOINT_SM
  // 界面是否显示
  @State isPageShow: boolean = false

  @Builder TabBarBuilder(title: ResourceStr, image: ResourceStr, index: number) {
    Column({ space: CommonConstants.SPACE_8 }) {
      Image(image)
        .width(22)
        .fillColor(this.selectorColor(index))
      Text(title)
        .fontSize(14)
        .fontColor(this.selectorColor(index))
    }
  }

  onPageShow() {
    this.isPageShow = true
  }

  onPageHide() {
    this.isPageShow = false
  }

  aboutToAppear() {
    this.breakPointSystem.register()
  }

  aboutToDisappear() {
    this.breakPointSystem.unregister()
  }

  // 获取选中的颜色值
  selectorColor(index: number) {
    return this.currentIndex === index ? $r('app.color.primary_color') : $r('app.color.gray')
  }

  chooseBarPosition() {
    /*  let p = {
        sm: BarPosition.End,
        md: BarPosition.Start,
        lg: BarPosition.Start,
      }
      return p[this.currentBreakPoint]*/
    // 简写形式
    return {
      sm: BarPosition.End,
      md: BarPosition.Start,
      lg: BarPosition.Start,
    }[this.currentBreakPoint]
  }

  build() {
    Tabs({ barPosition: BreakpointConstants.BAR_POSITION.getValue(this.currentBreakPoint) }) {

      // 记录首页
      TabContent() {
        RecordIndex({isPageShow:this.isPageShow})
      }.tabBar(this.TabBarBuilder($r('app.string.tab_record'), $r('app.media.ic_calendar'), 0))

      TabContent() {
        Row() {
          Text("发现页面")
          Text(this.currentBreakPoint)
        }
      }.tabBar(this.TabBarBuilder($r('app.string.tab_discover'), $r('app.media.discover'), 1))

      TabContent() {
        Text("我的主页")
      }.tabBar(this.TabBarBuilder($r('app.string.tab_user'), $r('app.media.ic_user_portrait'), 2))

    }.width('100%')
    .height('100%')
    .onChange(index => this.currentIndex = index)
    .vertical(new BreakpointType<boolean>({
      sm: false,
      md: true,
      lg: true,
    }).getValue(this.currentBreakPoint))
  }
}