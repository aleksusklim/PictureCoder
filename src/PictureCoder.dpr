program PictureCoder;
{$APPTYPE CONSOLE}
uses SysUtils,Classes,Math;

const
FFFFFFFF=$FFFFFFFF;
MaxFileSize=268435456;
P0=19778;
P1=0;
P2=54;
P3=40;
P4=1572865;
P5=0;
P6=768;
BMP_='.bmp';
PictureCoderDivisor='PICTURE_CODER_DIVISOR';
PictureCoderFraction='PICTURE_CODER_FRACTION';
helpfile:array[0..3237]of byte=(
$50,$69,$63,$74,$75,$72,$65,$43,$6F,$64,$65,$72,$20,$76,$31,$2E,
$31,$21,$20,$4B,$6C,$79,$5F,$4D,$65,$6E,$5F,$43,$4F,$6D,$70,$61,
$6E,$79,$2E,$0D,$0A,$0D,$0A,$8F,$E0,$AE,$A3,$E0,$A0,$AC,$AC,$A0,
$20,$AF,$AE,$A7,$A2,$AE,$AB,$EF,$A5,$E2,$20,$AF,$E0,$A5,$AE,$A1,
$E0,$A0,$A7,$AE,$A2,$A0,$E2,$EC,$20,$8B,$9E,$81,$8E,$89,$20,$E4,
$A0,$A9,$AB,$20,$A2,$20,$AA,$A0,$E0,$E2,$A8,$AD,$AA,$E3,$20,$42,
$69,$74,$6D,$61,$70,$2E,$0D,$0A,$8F,$E0,$A5,$A4,$AD,$A0,$A7,$AD,
$A0,$E7,$A5,$AD,$A0,$20,$AB,$A8,$A1,$AE,$20,$A4,$AB,$EF,$20,$AF,
$E0,$EF,$AC,$AE,$A3,$AE,$20,$AF,$A5,$E0,$A5,$E2,$A0,$E1,$AA,$A8,
$A2,$A0,$AD,$A8,$EF,$20,$E4,$A0,$A9,$AB,$AE,$A2,$2C,$20,$AB,$A8,
$A1,$AE,$20,$A4,$AB,$EF,$20,$E1,$AA,$E0,$A8,$AF,$E2,$AE,$A2,$20,
$42,$41,$54,$2E,$0D,$0A,$88,$E1,$AF,$AE,$AB,$EC,$A7,$AE,$A2,$A0,
$AD,$A8,$A5,$20,$2D,$20,$AF,$A5,$E0,$A5,$E2,$A0,$E9,$A8,$E2,$A5,
$20,$E4,$A0,$A9,$AB,$20,$AD,$A0,$20,$AF,$E0,$AE,$A3,$E0,$A0,$AC,
$AC,$E3,$3A,$0D,$0A,$50,$69,$63,$74,$75,$72,$65,$43,$6F,$64,$65,
$72,$2E,$65,$78,$65,$20,$5B,$41,$6E,$79,$46,$69,$6C,$65,$20,$7C,
$20,$49,$6D,$61,$67,$65,$2E,$62,$6D,$70,$5D,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$90,$A5,$A7,$E3,
$AB,$EC,$E2,$A0,$E2,$3A,$0D,$0A,$8F,$E0,$A8,$20,$AA,$AE,$A4,$A8,
$E0,$AE,$A2,$A0,$AD,$A8,$A8,$20,$2D,$20,$AD,$AE,$A2,$EB,$A9,$20,
$E4,$A0,$A9,$AB,$20,$E1,$20,$A8,$AC,$A5,$AD,$A5,$AC,$20,$A8,$E1,
$E5,$AE,$A4,$AD,$AE,$A3,$AE,$2B,$0D,$0A,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$60,$2E,$62,$6D,$70,$60,$20,$88,$8B,$88,
$20,$2B,$60,$2E,$7E,$60,$2C,$20,$A5,$E1,$AB,$A8,$20,$AD,$A5,$20,
$E3,$A4,$A0,$AB,$AE,$E1,$EC,$20,$AF,$A5,$E0,$A2,$EB,$A9,$2E,$0D,
$0A,$28,$AD,$A0,$AF,$E0,$A8,$AC,$A5,$E0,$20,$60,$43,$3A,$5C,$73,
$6F,$6E,$67,$2E,$6D,$70,$33,$60,$20,$E1,$E2,$A0,$AD,$A5,$E2,$20,
$60,$43,$3A,$5C,$73,$6F,$6E,$67,$2E,$6D,$70,$33,$2E,$62,$6D,$70,
$60,$20,$88,$8B,$88,$20,$60,$43,$3A,$5C,$73,$6F,$6E,$67,$2E,$6D,
$70,$33,$2E,$7E,$60,$29,$0D,$0A,$90,$A0,$E1,$E8,$A8,$E0,$A5,$AD,
$A8,$A5,$20,$28,$E2,$AE,$AB,$EC,$AA,$AE,$20,$E2,$AE,$2C,$20,$E7,
$E2,$AE,$20,$AF,$AE,$E1,$AB,$A5,$20,$AF,$AE,$E1,$AB,$A5,$A4,$AD,
$A5,$A9,$20,$E2,$AE,$E7,$AA,$A8,$29,$0D,$0A,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$A1,$E3,$A4,$A5,$E2,$20,$E1,$AE,$E5,
$E0,$A0,$AD,$A5,$AD,$AE,$20,$A2,$20,$AA,$A0,$E0,$E2,$A8,$AD,$AA,
$E3,$20,$A2,$AC,$A5,$E1,$E2,$A5,$20,$E1,$20,$A4,$A0,$AD,$AD,$EB,
$AC,$A8,$2E,$0D,$0A,$85,$E1,$AB,$A8,$20,$A5,$A3,$AE,$20,$AD,$A5,
$E2,$20,$2D,$20,$AF,$E0,$A8,$E0,$A0,$A2,$AD,$A8,$A2,$A0,$A5,$E2,
$E1,$EF,$20,$60,$2E,$7E,$60,$20,$8A,$A0,$E0,$E2,$A8,$AD,$AA,$E3,
$20,$8C,$8E,$86,$8D,$8E,$20,$AA,$AE,$AD,$A2,$A5,$E0,$E2,$A8,$E0,
$AE,$A2,$A0,$E2,$EC,$20,$A2,$20,$AB,$EE,$A1,$AE,$A9,$20,$E4,$AE,
$E0,$AC,$A0,$E2,$0D,$0A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$28,$AD,$AE,$20,$E2,$AE,$AB,$EC,$AA,$AE,$20,$A5,$E1,$AB,
$A8,$20,$A1,$A5,$A7,$20,$AF,$AE,$E2,$A5,$E0,$A8,$20,$AA,$A0,$E7,
$A5,$E1,$E2,$A2,$A0,$2C,$20,$AD,$A0,$AF,$E0,$A8,$AC,$A5,$E0,$20,
$50,$4E,$47,$29,$0D,$0A,$8F,$E0,$A8,$20,$A2,$AE,$E1,$E1,$E2,$A0,
$AD,$AE,$A2,$AB,$A5,$AD,$A8,$A8,$20,$2D,$20,$AD,$AE,$A2,$EB,$A9,
$20,$E4,$A0,$A9,$AB,$20,$E1,$20,$A8,$AC,$A5,$AD,$A5,$AC,$20,$A8,
$E1,$E5,$AE,$A4,$AD,$AE,$A3,$AE,$20,$2B,$20,$E0,$A0,$E1,$E8,$A8,
$E0,$A5,$AD,$A8,$A5,$2C,$0D,$0A,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$E1,$AE,$E5,$E0,$A0,$AD,$F1,$AD,$AD,$AE,
$A5,$20,$A2,$20,$AA,$A0,$E0,$E2,$A8,$AD,$AA,$A5,$20,$88,$8B,$88,
$20,$60,$2E,$7E,$60,$20,$28,$82,$20,$AF,$E0,$A8,$AC,$A5,$E0,$A5,
$20,$60,$43,$3A,$5C,$73,$6F,$6E,$67,$2E,$6D,$70,$33,$2E,$62,$6D,
$70,$2E,$6D,$70,$33,$60,$29,$0D,$0A,$90,$A0,$A7,$AC,$A5,$E0,$EB,
$20,$AF,$AE,$AB,$E3,$E7,$A0,$A5,$AC,$AE,$A9,$20,$AF,$E0,$A8,$20,
$AA,$AE,$A4,$A8,$E0,$AE,$A2,$A0,$AD,$A8,$A8,$20,$AA,$A0,$E0,$E2,
$A8,$AD,$AA,$A8,$20,$A2,$EB,$E7,$A8,$E1,$AB,$EF,$EE,$E2,$E1,$EF,
$20,$E1,$AB,$A5,$A4,$E3,$EE,$E9,$A8,$AC,$20,$AE,$A1,$E0,$A0,$A7,
$AE,$AC,$3A,$0D,$0A,$31,$29,$20,$98,$A8,$E0,$A8,$AD,$A0,$20,$A2,
$E1,$A5,$A3,$A4,$A0,$20,$AA,$E0,$A0,$E2,$AD,$A0,$20,$60,$38,$60,
$2E,$0D,$0A,$32,$29,$20,$8E,$E2,$AD,$AE,$E8,$A5,$AD,$A8,$A5,$20,
$A4,$AB,$A8,$AD,$AD,$AE,$A9,$20,$E1,$E2,$AE,$E0,$AE,$AD,$EB,$20,
$AA,$20,$AA,$AE,$E0,$AE,$E2,$AA,$AE,$A9,$0D,$0A,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$AD,$A5,$20,$AF,$E0,$A5,$A2,$AE,$E1,$E5,$AE,$A4,$A8,$E2,$20,
$60,$34,$2F,$33,$60,$2C,$20,$A5,$E1,$AB,$A8,$20,$A2,$AE,$A7,$AC,
$AE,$A6,$AD,$AE,$20,$AF,$AE,$20,$AF,$E3,$AD,$AA,$E2,$E3,$20,$31,
$2E,$0D,$0A,$33,$29,$20,$85,$E1,$AB,$A8,$20,$A2,$20,$AF,$E3,$AD,
$AA,$E2,$A5,$20,$32,$20,$A8,$AC,$A5,$A5,$E2,$E1,$EF,$20,$AD,$A5,
$E1,$AA,$AE,$AB,$EC,$AA,$AE,$20,$A2,$A0,$E0,$A8,$A0,$AD,$E2,$AE,
$A2,$2C,$20,$E2,$AE,$20,$A8,$E1,$AF,$AE,$AB,$EC,$A7,$E3,$A5,$E2,
$E1,$EF,$20,$E2,$AE,$E2,$2C,$0D,$0A,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A2,$20,
$AA,$AE,$E2,$AE,$E0,$AE,$AC,$20,$AD,$A5,$A7,$A0,$AD,$EF,$E2,$AE,
$A5,$20,$AF,$E0,$AE,$E1,$E2,$E0,$A0,$AD,$E1,$E2,$A2,$AE,$20,$A1,
$E3,$A4,$A5,$E2,$20,$AC,$A8,$AD,$A8,$AC,$A0,$AB,$EC,$AD,$AE,$2E,
$0D,$0A,$34,$29,$20,$85,$E1,$AB,$A8,$20,$AF,$AE,$E1,$AB,$A5,$20,
$AF,$E3,$AD,$AA,$E2,$A0,$20,$33,$20,$AE,$E1,$E2,$A0,$AB,$AE,$E1,
$EC,$20,$AD,$A5,$E1,$AA,$AE,$AB,$EC,$AA,$AE,$20,$AE,$A4,$A8,$AD,
$A0,$AA,$AE,$A2,$EB,$E5,$20,$AD,$A0,$A1,$AE,$E0,$AE,$A2,$2C,$20,
$E2,$AE,$20,$A1,$A5,$E0,$F1,$E2,$E1,$EF,$20,$E2,$AE,$E2,$2C,$0D,
$0A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$A3,$A4,$A5,$20,$AE,$E2,$AD,$AE,$E8,$A5,
$AD,$A8,$A5,$20,$E1,$E2,$AE,$E0,$AE,$AD,$20,$A1,$AB,$A8,$A6,$A5,
$20,$AA,$20,$AA,$A2,$A0,$A4,$E0,$A0,$E2,$E3,$2E,$0D,$0A,$88,$E1,
$AF,$AE,$AB,$EC,$A7,$AE,$A2,$A0,$AD,$AD,$EB,$A5,$20,$AA,$AE,$AD,
$E1,$E2,$A0,$AD,$E2,$EB,$20,$28,$60,$38,$60,$20,$A8,$20,$60,$31,
$2E,$33,$33,$33,$33,$33,$33,$33,$60,$29,$0D,$0A,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$AC,$AE,$A3,$E3,$E2,$20,$A1,$EB,
$E2,$EC,$20,$AF,$A5,$E0,$A5,$AE,$AF,$E0,$A5,$A4,$A5,$AB,$A5,$AD,
$EB,$20,$E1,$AB,$A5,$A4,$E3,$EE,$E9,$A8,$AC,$A8,$20,$AF,$A5,$E0,
$A5,$AC,$A5,$AD,$AD,$EB,$AC,$A8,$20,$E1,$E0,$A5,$A4,$EB,$3A,$0D,
$0A,$50,$49,$43,$54,$55,$52,$45,$5F,$43,$4F,$44,$45,$52,$5F,$44,
$49,$56,$49,$53,$4F,$52,$20,$2D,$20,$E6,$A5,$AB,$AE,$A5,$2C,$20,
$AA,$E0,$A0,$E2,$AD,$AE,$E1,$E2,$EC,$20,$E8,$A8,$E0,$A8,$AD,$EB,
$20,$28,$31,$20,$A4,$AB,$EF,$20,$AB,$EE,$A1,$AE,$A9,$29,$3B,$AD,
$A5,$E7,$F1,$E2,$AD,$EB,$A5,$0D,$0A,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$A7,$AD,$A0,$E7,$A5,$AD,$A8,$EF,$20,$AC,$AE,$A3,$E3,
$E2,$20,$A2,$EB,$A7,$A2,$A0,$E2,$EC,$20,$AE,$E8,$A8,$A1,$AE,$E7,
$AD,$EB,$A5,$20,$AA,$A0,$E0,$E2,$A8,$AD,$AA,$A8,$2E,$0D,$0A,$50,
$49,$43,$54,$55,$52,$45,$5F,$43,$4F,$44,$45,$52,$5F,$46,$52,$41,
$43,$54,$49,$4F,$4E,$20,$2D,$20,$A4,$E0,$AE,$A1,$AD,$AE,$A5,$2C,
$20,$AC,$A0,$AA,$E1,$A8,$AC,$A0,$AB,$EC,$AD,$AE,$A5,$20,$AE,$E2,
$AD,$AE,$E8,$A5,$AD,$A8,$A5,$20,$E1,$E2,$AE,$E0,$AE,$AD,$0D,$0A,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$28,$31,
$20,$2D,$20,$E2,$AE,$AB,$EC,$AA,$AE,$20,$AA,$A2,$A0,$A4,$E0,$A0,
$E2,$29,$3B,$20,$A5,$E1,$AB,$A8,$20,$AC,$A5,$AD,$EC,$E8,$A5,$20,
$AD,$E3,$AB,$EF,$2C,$20,$E2,$AE,$20,$A1,$A5,$E0,$F1,$E2,$E1,$EF,
$20,$AE,$A1,$E0,$A0,$E2,$AD,$AE,$A5,$20,$28,$31,$2F,$58,$29,$0D,
$0A,$8F,$E0,$A8,$AC,$A5,$E0,$AD,$EB,$A9,$20,$42,$61,$74,$63,$68,
$20,$AA,$AE,$A4,$20,$A4,$AB,$EF,$20,$A8,$E5,$20,$A8,$A7,$AC,$A5,
$AD,$A5,$AD,$A8,$EF,$3A,$0D,$0A,$0D,$0A,$73,$65,$74,$20,$2F,$41,
$20,$50,$49,$43,$54,$55,$52,$45,$5F,$43,$4F,$44,$45,$52,$5F,$44,
$49,$56,$49,$53,$4F,$52,$3D,$34,$0D,$0A,$73,$65,$74,$20,$2F,$41,
$20,$50,$49,$43,$54,$55,$52,$45,$5F,$43,$4F,$44,$45,$52,$5F,$46,
$52,$41,$43,$54,$49,$4F,$4E,$3D,$37,$32,$30,$2F,$32,$34,$30,$0D,
$0A,$50,$69,$63,$74,$75,$72,$65,$43,$6F,$64,$65,$72,$2E,$65,$78,
$65,$20,$25,$31,$0D,$0A,$49,$66,$20,$45,$52,$52,$4F,$52,$4C,$45,
$56,$45,$4C,$20,$31,$20,$65,$63,$68,$6F,$20,$46,$61,$69,$6C,$21,
$0D,$0A,$0D,$0A,$84,$AB,$EF,$20,$AF,$AE,$AB,$E3,$E7,$A5,$AD,$A8,
$EF,$20,$E1,$A2,$A5,$A4,$A5,$AD,$A8,$A9,$20,$AE,$20,$E0,$A5,$A7,
$E3,$AB,$EC,$E2,$A0,$E2,$A5,$20,$AF,$E0,$A5,$AE,$A1,$E0,$A0,$A7,
$AE,$A2,$A0,$AD,$A8,$EF,$20,$AC,$AE,$A6,$AD,$AE,$20,$A8,$E1,$AF,
$AE,$AB,$EC,$A7,$AE,$A2,$A0,$E2,$EC,$20,$AB,$A8,$A1,$AE,$0D,$0A,
$20,$20,$20,$20,$20,$20,$20,$20,$AA,$AE,$A4,$20,$A2,$AE,$A7,$A2,
$E0,$A0,$E2,$A0,$20,$25,$45,$52,$52,$4F,$52,$4C,$45,$56,$45,$4C,
$25,$2C,$20,$AB,$A8,$A1,$AE,$20,$E7,$A8,$E1,$AB,$AE,$2C,$20,$A2,
$EB,$A2,$A5,$A4,$A5,$AD,$AD,$AE,$A5,$20,$A2,$20,$AA,$AE,$AD,$E1,
$AE,$AB,$EC,$2E,$0D,$0A,$90,$A0,$E1,$E8,$A8,$E4,$E0,$AE,$A2,$AA,
$A8,$20,$AA,$AE,$A4,$A0,$20,$A2,$AE,$A7,$A2,$E0,$A0,$E2,$A0,$3A,
$0D,$0A,$0D,$0A,$30,$20,$2D,$20,$93,$E1,$AF,$A5,$E5,$20,$AE,$AF,
$A5,$E0,$A0,$E6,$A8,$A8,$2E,$0D,$0A,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$82,$EB,$A2,$AE,$A4,$20,$A2,$20,$AA,$AE,
$AD,$E1,$AE,$AB,$EC,$20,$E0,$A0,$E1,$E8,$A8,$E0,$A5,$AD,$A8,$EF,
$20,$E1,$AE,$A7,$A4,$A0,$AD,$AD,$AE,$A3,$AE,$20,$E4,$A0,$A9,$AB,
$A0,$20,$E1,$20,$E2,$AE,$E7,$AA,$AE,$A9,$20,$A2,$AF,$A5,$E0,$A5,
$A4,$A8,$2E,$0D,$0A,$31,$20,$2D,$20,$8E,$E8,$A8,$A1,$AA,$A0,$20,
$AE,$E2,$AA,$E0,$EB,$E2,$A8,$EF,$20,$A2,$E5,$AE,$A4,$AD,$AE,$A3,
$AE,$20,$E4,$A0,$A9,$AB,$A0,$20,$88,$8B,$88,$0D,$0A,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$A5,$A3,$AE,$20,$E0,$A0,$A7,$AC,$A5,
$E0,$20,$AF,$E0,$A5,$A2,$AE,$E1,$E5,$AE,$A4,$A8,$E2,$20,$32,$35,
$36,$20,$8C,$A1,$20,$28,$AF,$E0,$A8,$20,$AA,$AE,$A4,$A8,$E0,$AE,
$A2,$A0,$AD,$A8,$A8,$29,$2E,$0D,$0A,$32,$20,$2D,$20,$8E,$E8,$A8,
$A1,$AA,$A0,$20,$E1,$AE,$A7,$A4,$A0,$AD,$A8,$EF,$20,$A2,$EB,$E5,
$AE,$A4,$AD,$AE,$A3,$AE,$20,$E4,$A0,$A9,$AB,$A0,$0D,$0A,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A4,$A0,$A6,$A5,$20,
$E1,$AE,$20,$A2,$E2,$AE,$E0,$AE,$A9,$20,$AF,$AE,$AF,$EB,$E2,$AA,
$A8,$20,$28,$E1,$20,$E0,$A0,$E1,$E8,$A8,$E0,$A5,$AD,$A8,$A5,$AC,
$20,$60,$2E,$7E,$60,$20,$29,$2E,$0D,$0A,$33,$20,$2D,$20,$8E,$E8,
$A8,$A1,$AA,$A0,$20,$E7,$E2,$A5,$AD,$A8,$EF,$20,$42,$69,$74,$4D,
$61,$70,$20,$A7,$A0,$A3,$AE,$AB,$AE,$A2,$AA,$A0,$20,$88,$8B,$88,
$0D,$0A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$AE,$E8,$A8,$A1,$AA,$A0,$20,
$A7,$A0,$AF,$A8,$E1,$A8,$20,$ED,$E2,$AE,$A3,$AE,$20,$A7,$A0,$A3,
$AE,$AB,$AE,$A2,$AA,$A0,$20,$28,$AF,$E0,$A8,$20,$A2,$AE,$E1,$E1,
$E2,$A0,$AD,$AE,$A2,$AB,$A5,$AD,$A8,$A8,$29,$2E,$0D,$0A,$34,$20,
$2D,$20,$8E,$E8,$A8,$A1,$AA,$A0,$20,$AA,$AE,$AF,$A8,$E0,$AE,$A2,
$A0,$AD,$A8,$EF,$20,$E1,$AE,$A4,$A5,$E0,$A6,$A8,$AC,$AE,$A3,$AE,
$20,$AC,$A5,$A6,$A4,$E3,$20,$E4,$A0,$A9,$AB,$A0,$AC,$A8,$2E,$0D,
$0A,$35,$20,$2D,$20,$8A,$AE,$AB,$A8,$E7,$A5,$E1,$E2,$A2,$AE,$20,
$A0,$E0,$A3,$E3,$AC,$A5,$AD,$E2,$AE,$A2,$20,$AD,$A5,$20,$E0,$A0,
$A2,$AD,$AE,$20,$AE,$A4,$AD,$AE,$AC,$E3,$20,$88,$8B,$88,$0D,$0A,
$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
$20,$20,$20,$20,$20,$A2,$E5,$AE,$A4,$AD,$AE,$A9,$20,$E4,$A0,$A9,
$AB,$20,$AD,$A5,$20,$AD,$A0,$A9,$A4,$A5,$AD,$3B,$20,$A2,$EB,$A2,
$AE,$A4,$20,$ED,$E2,$AE,$A9,$20,$E1,$AF,$E0,$A0,$A2,$AA,$A8,$20,
$A2,$20,$AA,$AE,$AD,$E1,$AE,$AB,$EC,$2E,$0D,$0A,$0D,$0A,$87,$A0,
$20,$A8,$E1,$AA,$AB,$EE,$E7,$A5,$AD,$A8,$A5,$AC,$20,$30,$20,$A8,
$20,$35,$2C,$20,$A2,$20,$AA,$AE,$AD,$E1,$AE,$AB,$EC,$20,$A2,$EB,
$A2,$AE,$A4,$A8,$E2,$E1,$EF,$20,$E2,$AE,$E2,$20,$A6,$A5,$20,$E1,
$A0,$AC,$EB,$A9,$20,$AA,$AE,$A4,$20,$A2,$AE,$A7,$A2,$E0,$A0,$E2,
$A0,$2E,$0D,$0A,$90,$A0,$E1,$E8,$A8,$E0,$A5,$AD,$A8,$A5,$20,$AF,
$E0,$A8,$20,$E3,$E1,$AF,$A5,$E5,$A5,$20,$AF,$A5,$E0,$A5,$A4,$A0,
$F1,$E2,$E1,$EF,$20,$A4,$AB,$EF,$20,$E2,$AE,$A3,$AE,$2C,$20,$E7,
$E2,$AE,$A1,$EB,$20,$A1,$EB,$AB,$AE,$20,$A8,$A7,$A2,$A5,$E1,$E2,
$AD,$AE,$20,$A8,$AC,$EF,$20,$AD,$AE,$A2,$AE,$A3,$AE,$0D,$0A,$20,
$E4,$A0,$A9,$AB,$A0,$2C,$20,$AF,$AE,$E2,$AE,$AC,$E3,$20,$AA,$A0,
$AA,$20,$AE,$AD,$AE,$20,$A8,$A7,$A2,$AB,$A5,$AA,$A0,$A5,$E2,$E1,
$EF,$20,$A8,$A7,$20,$E1,$A0,$AC,$AE,$A9,$20,$AA,$A0,$E0,$E2,$A8,
$AD,$AA,$A8,$20,$A8,$20,$AD,$A5,$A8,$A7,$A2,$A5,$E1,$E2,$AD,$AE,
$20,$A7,$A0,$E0,$A0,$AD,$A5,$A5,$2E,$0D,$0A,$82,$AE,$E2,$20,$AF,
$E0,$A8,$AC,$A5,$E0,$20,$E1,$E6,$A5,$AD,$A0,$E0,$A8,$EF,$2C,$0D,
$0A,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$A7,$A0,
$AF,$E3,$E1,$AA,$A0,$EE,$E9,$A5,$A3,$AE,$20,$E0,$A5,$A7,$E3,$AB,
$EC,$E2,$A0,$E2,$20,$AE,$A1,$E0,$A0,$A1,$AE,$E2,$AA,$A8,$20,$AF,
$A5,$E0,$A5,$E2,$A0,$E9,$A5,$AD,$AD,$AE,$A3,$AE,$20,$AD,$A0,$20,
$AD,$A5,$A3,$AE,$20,$E4,$A0,$A9,$AB,$A0,$3A,$0D,$0A,$0D,$0A,$40,
$65,$63,$68,$6F,$20,$6F,$66,$66,$0D,$0A,$63,$64,$20,$2F,$44,$20,
$25,$7E,$64,$70,$30,$0D,$0A,$66,$6F,$72,$20,$2F,$46,$20,$22,$75,
$73,$65,$62,$61,$63,$6B,$71,$22,$20,$25,$25,$49,$20,$69,$6E,$20,
$28,$60,$50,$69,$63,$74,$75,$72,$65,$43,$6F,$64,$65,$72,$2E,$65,
$78,$65,$20,$25,$31,$60,$29,$20,$64,$6F,$20,$73,$65,$74,$20,$66,
$69,$6C,$65,$3D,$25,$25,$49,$0D,$0A,$69,$66,$20,$22,$25,$66,$69,
$6C,$65,$3A,$7E,$30,$2C,$31,$25,$22,$20,$3D,$3D,$20,$22,$2E,$22,
$20,$73,$74,$61,$72,$74,$20,$22,$22,$20,$22,$25,$7E,$31,$25,$66,
$69,$6C,$65,$25,$22,$00);


type header=packed record
P0:word;
Size,P1,P2,P3,Width,Height,P4,P5,P6:Cardinal;
P7:array [0..15] of byte;
end;

var Width,Height,Modifer,Size,Square,Last,Count,Good,New,Curr:Cardinal;
Divider:Real;
Head:header;
lSquare:Byte;
Ok:Boolean;
i:Integer;
Ext,BMP:AnsiString;
stream,save:TFileStream;
PC:PChar;

//procedure ExitProcess(Code:integer);stdcall; external 'kernel32.dll';
function GetEnvironmentVariableA(stin,stout,size:integer):integer;
stdcall; external 'kernel32.dll';
function envget(name:AnsiString):AnsiString;
var i:Cardinal;s:ShortString;
begin i:=GetEnvironmentVariableA(Integer(PChar(name)),Integer(@s)+1,255);
SetLength(s,i);Result:=s;end;

function makedivide(divident,divisor:Cardinal;var large:Byte):Cardinal;
begin
large:=divident mod divisor;
if large=0 then begin
Result:=divident;large:=1;
end else begin
if large<(divisor div 2) then begin
Result:=divident-large;large:=0;
end else begin
Result:=divisor-large+divident;large:=1;
end;end;end;

function setdivide(divident,divisor:Cardinal;large:Boolean):Cardinal;
var m:Cardinal;begin
m:=divident mod divisor;
if m=0 then Result:=divident
else begin if large
then Result:=divisor-m+divident
else Result:=divident-m;end;end;

function getextension(S:string):string;
var I:Cardinal;
begin Result:='';
for I:=Length(S)-1 downto 1 do
if S[I]='.' then begin
Result:=Copy(S,I,Length(S)-I+1);break;end;
if Length(Result)>255 then Result:='';end;

procedure help;
begin Writeln(PChar(@helpfile));Halt(5);end;

procedure Stop(const Code:Integer);
begin Write(Code);
Halt(Code);end;

begin
if (ParamCount<>1)then help;
if not FileExists(ParamStr(1))then help;
Ext:=getextension(ParamStr(1));
if LowerCase(Ext)=BMP_ then begin
try stream:=TFileStream.Create(ParamStr(1),fmOpenRead,fmShareDenyNone);
except Stop(1);end;
try stream.ReadBuffer(Head,sizeof(Head));stream.ReadBuffer(lSquare,1);
SetLength(Ext,lSquare);PC:=PChar(Ext);
if lSquare>0 then stream.ReadBuffer(PC^,lSquare);Ext:='.'+PC;
stream.ReadBuffer(Count,4);
except Stop(3);end;
try save:=TFileStream.Create(ParamStr(1)+Ext,fmCreate);
except Ext:=Ext+'~';try save:=TFileStream.Create(ParamStr(1)+Ext,fmCreate);
except Stop(2);end;end;
if Count>0 then begin
try save.CopyFrom(stream,Count);
except Stop(4);end;end;
save.Free;stream.Free;
Write(Ext);Halt(0);
end else begin

Val(envget(PictureCoderDivisor),Modifer,i);
if i>0 then Modifer:=8;
if Modifer<1 then Modifer:=1;
Val(StringReplace(envget(PictureCoderFraction),',','.',[]),Divider,i);
if i>0 then Divider:=4/3;
if Divider<1 then Divider:=1/Divider;
BMP:=BMP_;

if Ext='' then Ext:='.~';
try stream:=TFileStream.Create(ParamStr(1),fmOpenRead,fmShareDenyNone);
except Stop(1);end;
if stream.Size>268435456 then Stop(1);

Size:=Ceil((stream.Size+3+Length(Ext))/3);
Square:=makedivide(Round(Sqrt(Size)),Modifer,lSquare);
Width:=setdivide(Round(Sqrt(Size*Divider)),Modifer,false);
Height:=setdivide(Round(Sqrt(Size/Divider)),Modifer,true);
if Width*Height=0 then begin
Square:=setdivide(Round(Sqrt(Size)),Modifer,true);
Width:=Square;lSquare:=1;
Height:=Ceil(Size/Width);end;
Last:=FFFFFFFF;Good:=Last;
Count:=0;Ok:=false;repeat
if Odd(Count+lSquare) then
New:=Square+Count*Modifer else
New:=Square-Count*Modifer;
if New<1 then begin Inc(Count);
if Ok then Break;Ok:=true;Continue;end;
Curr:=(New*Ceil(Size/New))-Size;
if (Curr<Last)and(New<=Width)
and(New>=Height)then begin
Last:=Curr;Good:=New;end;
if Ok then Break;
if (New>Width)or(New<Height)
then Ok:=true;
Inc(Count);until false;
if Good=FFFFFFFF then Good:=Square;
Width:=Good;Height:=Ceil(Size/Good);

Head.P0:=P0;Head.P1:=P1;Head.P2:=P2;
Head.P3:=P3;Head.P4:=P4;Head.P5:=P5;Head.P6:=P6;
Head.Width:=Width;Head.Height:=Height;
Head.Size:=sizeof(Head)+Width*Height*3;

try save:=TFileStream.Create(ParamStr(1)+BMP,fmCreate);
except try BMP:=BMP+'~';
save:=TFileStream.Create(ParamStr(1)+BMP,fmCreate);
except Stop(2);end;end; try
save.WriteBuffer(Head,sizeof(Head));lSquare:=Length(Ext)-1;
PC:=PChar(copy(Ext,2,lSquare));
save.WriteBuffer(lSquare,1);save.WriteBuffer(PC^,lSquare);
Count:=stream.Size;save.WriteBuffer(Count,4);
except Stop(3);end; try
save.CopyFrom(stream,0);lSquare:=0;
while save.Size<Head.Size do save.WriteBuffer(lSquare,1);
except Stop(4);end;
save.Free;stream.Free;
Write(BMP);Halt(0);
end;end.
