; ModuleID = '/home/ruslan/llvm-course/mines/lib/mines.c'
source_filename = "/home/ruslan/llvm-course/mines/lib/mines.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@FieldState = internal global [20 x [20 x i64]] zeroinitializer, align 16
@FieldNeighbors = internal global [20 x [20 x i64]] zeroinitializer, align 16
@FieldType = internal unnamed_addr global [20 x [20 x i64]] zeroinitializer, align 16
@GameOver = internal unnamed_addr global i1 false, align 8

; Function Attrs: nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = alloca i64, align 8
  %2 = alloca i64, align 8
  br label %3

3:                                                ; preds = %5, %0
  %4 = phi i64 [ 0, %0 ], [ %6, %5 ]
  br label %14

5:                                                ; preds = %14
  %6 = add nuw nsw i64 %4, 1
  %7 = icmp eq i64 %6, 20
  br i1 %7, label %8, label %3, !llvm.loop !5

8:                                                ; preds = %5
  %9 = call i64 (...) @simHasQuit() #4
  %10 = icmp eq i64 %9, 0
  br i1 %10, label %11, label %25

11:                                               ; preds = %8
  %12 = bitcast i64* %1 to i8*
  %13 = bitcast i64* %2 to i8*
  br label %26

14:                                               ; preds = %14, %3
  %15 = phi i64 [ 0, %3 ], [ %23, %14 ]
  %16 = tail call i64 (...) @simRand() #4
  %17 = srem i64 %16, 100
  %18 = icmp slt i64 %17, 10
  %19 = zext i1 %18 to i64
  %20 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %4, i64 %15
  store i64 %19, i64* %20, align 8, !tbaa !7
  %21 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldState, i64 0, i64 %4, i64 %15
  store i64 0, i64* %21, align 8, !tbaa !7
  %22 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldNeighbors, i64 0, i64 %4, i64 %15
  store i64 0, i64* %22, align 8, !tbaa !7
  %23 = add nuw nsw i64 %15, 1
  %24 = icmp eq i64 %23, 20
  br i1 %24, label %5, label %14, !llvm.loop !11

25:                                               ; preds = %56, %8
  call void (...) @simExit() #4
  ret void

26:                                               ; preds = %11, %56
  %27 = load i1, i1* @GameOver, align 8
  br i1 %27, label %56, label %28

28:                                               ; preds = %26
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %12) #4
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %13) #4
  %29 = call i64 @simPollClick(i64* noundef nonnull %1, i64* noundef nonnull %2) #4
  %30 = icmp eq i64 %29, 0
  br i1 %30, label %55, label %31

31:                                               ; preds = %28
  %32 = load i64, i64* %1, align 8, !tbaa !7
  %33 = add nsw i64 %32, -408
  %34 = sdiv i64 %33, 36
  %35 = load i64, i64* %2, align 8, !tbaa !7
  %36 = add nsw i64 %35, -24
  %37 = sdiv i64 %36, 36
  %38 = add i64 %32, -1128
  %39 = icmp ult i64 %38, -755
  %40 = icmp slt i64 %35, -11
  %41 = select i1 %39, i1 true, i1 %40
  %42 = icmp sgt i64 %35, 743
  %43 = select i1 %41, i1 true, i1 %42
  br i1 %43, label %55, label %44

44:                                               ; preds = %31
  switch i64 %29, label %55 [
    i64 1, label %45
    i64 2, label %50
  ]

45:                                               ; preds = %44
  %46 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldState, i64 0, i64 %37, i64 %34
  %47 = load i64, i64* %46, align 8, !tbaa !7
  %48 = icmp eq i64 %47, 0
  br i1 %48, label %49, label %55

49:                                               ; preds = %45
  call fastcc void @openCell(i64 noundef %34, i64 noundef %37) #4
  br label %55

50:                                               ; preds = %44
  %51 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldState, i64 0, i64 %37, i64 %34
  %52 = load i64, i64* %51, align 8, !tbaa !7
  switch i64 %52, label %55 [
    i64 0, label %53
    i64 2, label %54
  ]

53:                                               ; preds = %50
  store i64 2, i64* %51, align 8, !tbaa !7
  br label %55

54:                                               ; preds = %50
  store i64 0, i64* %51, align 8, !tbaa !7
  br label %55

55:                                               ; preds = %54, %53, %50, %49, %45, %44, %31, %28
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %13) #4
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %12) #4
  br label %56

56:                                               ; preds = %26, %55
  call void @renderField([20 x i64]* noundef getelementptr inbounds ([20 x [20 x i64]], [20 x [20 x i64]]* @FieldState, i64 0, i64 0), [20 x i64]* noundef getelementptr inbounds ([20 x [20 x i64]], [20 x [20 x i64]]* @FieldNeighbors, i64 0, i64 0)) #4
  call void (...) @simFlush() #4
  %57 = call i64 (...) @simHasQuit() #4
  %58 = icmp eq i64 %57, 0
  br i1 %58, label %26, label %25
}

declare i64 @simHasQuit(...) local_unnamed_addr #1

declare void @simExit(...) local_unnamed_addr #1

declare void @renderField([20 x i64]* noundef, [20 x i64]* noundef) local_unnamed_addr #1

declare void @simFlush(...) local_unnamed_addr #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  tail call void (...) @simInit() #4
  tail call void @app()
  ret i32 0
}

declare void @simInit(...) local_unnamed_addr #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

declare i64 @simRand(...) local_unnamed_addr #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

declare i64 @simPollClick(i64* noundef, i64* noundef) local_unnamed_addr #1

; Function Attrs: nofree nosync nounwind uwtable
define internal fastcc void @openCell(i64 noundef %0, i64 noundef %1) unnamed_addr #3 {
  %3 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldState, i64 0, i64 %1, i64 %0
  %4 = load i64, i64* %3, align 8, !tbaa !7
  %5 = icmp eq i64 %4, 0
  br i1 %5, label %6, label %127

6:                                                ; preds = %2
  %7 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %1, i64 %0
  %8 = load i64, i64* %7, align 8, !tbaa !7
  %9 = icmp eq i64 %8, 1
  br i1 %9, label %10, label %11

10:                                               ; preds = %6
  store i64 3, i64* %3, align 8, !tbaa !7
  store i1 true, i1* @GameOver, align 8
  br label %127

11:                                               ; preds = %6
  store i64 1, i64* %3, align 8, !tbaa !7
  %12 = add i64 %1, -1
  %13 = add nsw i64 %0, -1
  %14 = icmp ult i64 %13, 20
  %15 = icmp ult i64 %12, 20
  %16 = and i1 %14, %15
  br i1 %16, label %17, label %22

17:                                               ; preds = %11
  %18 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %12, i64 %13
  %19 = load i64, i64* %18, align 8, !tbaa !7
  %20 = icmp eq i64 %19, 1
  %21 = zext i1 %20 to i64
  br label %22

22:                                               ; preds = %17, %11
  %23 = phi i64 [ 0, %11 ], [ %21, %17 ]
  %24 = icmp ult i64 %0, 20
  %25 = and i1 %24, %15
  br i1 %25, label %26, label %32

26:                                               ; preds = %22
  %27 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %12, i64 %0
  %28 = load i64, i64* %27, align 8, !tbaa !7
  %29 = icmp eq i64 %28, 1
  %30 = zext i1 %29 to i64
  %31 = add nuw nsw i64 %23, %30
  br label %32

32:                                               ; preds = %26, %22
  %33 = phi i64 [ %23, %22 ], [ %31, %26 ]
  %34 = add nsw i64 %0, 1
  %35 = icmp ult i64 %34, 20
  %36 = and i1 %35, %15
  br i1 %36, label %37, label %43

37:                                               ; preds = %32
  %38 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %12, i64 %34
  %39 = load i64, i64* %38, align 8, !tbaa !7
  %40 = icmp eq i64 %39, 1
  %41 = zext i1 %40 to i64
  %42 = add nuw nsw i64 %33, %41
  br label %43

43:                                               ; preds = %37, %32
  %44 = phi i64 [ %33, %32 ], [ %42, %37 ]
  %45 = icmp ult i64 %1, 20
  %46 = and i1 %45, %14
  br i1 %46, label %47, label %53

47:                                               ; preds = %43
  %48 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %1, i64 %13
  %49 = load i64, i64* %48, align 8, !tbaa !7
  %50 = icmp eq i64 %49, 1
  %51 = zext i1 %50 to i64
  %52 = add nuw nsw i64 %44, %51
  br label %53

53:                                               ; preds = %47, %43
  %54 = phi i64 [ %44, %43 ], [ %52, %47 ]
  %55 = and i1 %45, %35
  br i1 %55, label %56, label %62

56:                                               ; preds = %53
  %57 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %1, i64 %34
  %58 = load i64, i64* %57, align 8, !tbaa !7
  %59 = icmp eq i64 %58, 1
  %60 = zext i1 %59 to i64
  %61 = add nuw nsw i64 %54, %60
  br label %62

62:                                               ; preds = %56, %53
  %63 = phi i64 [ %54, %53 ], [ %61, %56 ]
  %64 = add i64 %1, 1
  %65 = icmp ult i64 %64, 20
  %66 = and i1 %14, %65
  br i1 %66, label %67, label %73

67:                                               ; preds = %62
  %68 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %64, i64 %13
  %69 = load i64, i64* %68, align 8, !tbaa !7
  %70 = icmp eq i64 %69, 1
  %71 = zext i1 %70 to i64
  %72 = add nuw nsw i64 %63, %71
  br label %73

73:                                               ; preds = %67, %62
  %74 = phi i64 [ %63, %62 ], [ %72, %67 ]
  %75 = and i1 %24, %65
  br i1 %75, label %76, label %82

76:                                               ; preds = %73
  %77 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %64, i64 %0
  %78 = load i64, i64* %77, align 8, !tbaa !7
  %79 = icmp eq i64 %78, 1
  %80 = zext i1 %79 to i64
  %81 = add nuw nsw i64 %74, %80
  br label %82

82:                                               ; preds = %76, %73
  %83 = phi i64 [ %74, %73 ], [ %81, %76 ]
  %84 = and i1 %35, %65
  br i1 %84, label %85, label %91

85:                                               ; preds = %82
  %86 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldType, i64 0, i64 %64, i64 %34
  %87 = load i64, i64* %86, align 8, !tbaa !7
  %88 = icmp eq i64 %87, 1
  %89 = zext i1 %88 to i64
  %90 = add nuw nsw i64 %83, %89
  br label %91

91:                                               ; preds = %82, %85
  %92 = phi i64 [ %83, %82 ], [ %90, %85 ]
  %93 = getelementptr inbounds [20 x [20 x i64]], [20 x [20 x i64]]* @FieldNeighbors, i64 0, i64 %1, i64 %0
  store i64 %92, i64* %93, align 8, !tbaa !7
  %94 = icmp eq i64 %92, 0
  br i1 %94, label %95, label %127

95:                                               ; preds = %91
  %96 = icmp ult i64 %12, 20
  %97 = and i1 %96, %14
  br i1 %97, label %98, label %99

98:                                               ; preds = %95
  tail call fastcc void @openCell(i64 noundef %13, i64 noundef %12)
  br label %99

99:                                               ; preds = %98, %95
  %100 = icmp ult i64 %12, 20
  %101 = and i1 %100, %24
  br i1 %101, label %102, label %103

102:                                              ; preds = %99
  tail call fastcc void @openCell(i64 noundef %0, i64 noundef %12)
  br label %103

103:                                              ; preds = %99, %102
  %104 = icmp ult i64 %12, 20
  %105 = and i1 %104, %35
  br i1 %105, label %106, label %107

106:                                              ; preds = %103
  tail call fastcc void @openCell(i64 noundef %34, i64 noundef %12)
  br label %107

107:                                              ; preds = %103, %106
  %108 = icmp ult i64 %1, 20
  %109 = and i1 %108, %14
  br i1 %109, label %110, label %111

110:                                              ; preds = %107
  tail call fastcc void @openCell(i64 noundef %13, i64 noundef %1)
  br label %111

111:                                              ; preds = %110, %107
  %112 = icmp ult i64 %1, 20
  %113 = and i1 %112, %35
  br i1 %113, label %114, label %115

114:                                              ; preds = %111
  tail call fastcc void @openCell(i64 noundef %34, i64 noundef %1)
  br label %115

115:                                              ; preds = %111, %114
  %116 = icmp ult i64 %64, 20
  %117 = and i1 %116, %14
  br i1 %117, label %118, label %119

118:                                              ; preds = %115
  tail call fastcc void @openCell(i64 noundef %13, i64 noundef %64)
  br label %119

119:                                              ; preds = %115, %118
  %120 = icmp ult i64 %64, 20
  %121 = and i1 %120, %24
  br i1 %121, label %122, label %123

122:                                              ; preds = %119
  tail call fastcc void @openCell(i64 noundef %0, i64 noundef %64)
  br label %123

123:                                              ; preds = %119, %122
  %124 = icmp ult i64 %64, 20
  %125 = and i1 %124, %35
  br i1 %125, label %126, label %127

126:                                              ; preds = %123
  tail call fastcc void @openCell(i64 noundef %34, i64 noundef %64)
  br label %127

127:                                              ; preds = %123, %126, %2, %10, %91
  ret void
}

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { nofree nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"long", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = distinct !{!11, !6}
