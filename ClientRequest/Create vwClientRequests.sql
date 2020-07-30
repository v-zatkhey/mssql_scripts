USE [Chest35]
GO

/****** Object:  View [dbo].[vwClientRequests]    Script Date: 07/24/2020 18:01:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--CREATE VIEW [dbo].[vwClientRequests]
ALTER VIEW [dbo].[vwClientRequests]
AS
SELECT     dbo.tblClientRequests.ID, dbo.tblClientRequests.ClientCode, dbo.tblClientRequests.ClientName, dbo.tblClientRequests.Number, dbo.tblClientRequests.AddDate, 
                      dbo.tblClientRequests.MsgText, dbo.tblПользователи.Пользователь AS AddEmploee, dbo.tblClientRequests.AnswerDate, dbo.tblClientRequests.AnswerText, 
                      tblПользователи_1.Пользователь AS AnswerEmployee, dbo.tblClientRequests.HasAnswer, dbo.tblЗапросы.Код_запроса AS QueryCode, 
                      dbo.tblЗаказы.Код_заказа AS OrderCode
FROM                  dbo.tblClientRequests INNER JOIN
                      dbo.tblПользователи ON dbo.tblClientRequests.AddEmployee = dbo.tblПользователи.Код left JOIN
                      dbo.tblПользователи AS tblПользователи_1 ON dbo.tblClientRequests.AnswerEmployee = tblПользователи_1.Код left JOIN
                      dbo.tblЗапросы ON dbo.tblClientRequests.QueryID = dbo.tblЗапросы.Код left JOIN
                      dbo.tblЗаказы ON dbo.tblClientRequests.OrderID = dbo.tblЗаказы.Код

GO

/*
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[36] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Customers"
            Begin Extent = 
               Top = 2
               Left = 8
               Bottom = 110
               Right = 168
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "tblClientRequests"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 276
               Right = 398
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblПользователи"
            Begin Extent = 
               Top = 27
               Left = 471
               Bottom = 135
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblПользователи_1"
            Begin Extent = 
               Top = 154
               Left = 465
               Bottom = 262
               Right = 750
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblЗапросы"
            Begin Extent = 
               Top = 98
               Left = 20
               Bottom = 206
               Right = 171
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "tblЗаказы"
            Begin Extent = 
               Top = 212
               Left = 5
               Bottom = 366
               Right = 180
            End
            DisplayFlags = 344
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
        ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwClientRequests'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' Column = 1440
         Alias = 1800
         Table = 2085
         Output = 1290
         Append = 1400
         NewValue = 1170
         SortType = 2055
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwClientRequests'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwClientRequests'
GO
*/

