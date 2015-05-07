//
//  Chronometer.m
//  SemNomeTro
//
//  Created by Giovani Ferreira Silvério da Silva on 07/04/15.
//  Copyright (c) 2015 Giovani Ferreira Silvério da Silva. All rights reserved.
//

#import "Chronometer.h"
#import <AudioToolbox/AudioServices.h>
#import "TableView_Model.h"
#import "PickerView_Model.h"
#import <QuartzCore/QuartzCore.h>

@interface Chronometer ()

@property (nonatomic) NSDate *startRest;
@property (nonatomic) BOOL inRest;
@property (nonatomic) NSNumber *currentTime;
@property (nonatomic) NSNumber *pausedTime;

//Icones/frescurinhas do cronomometro
@property (nonatomic) UIView *maskView;
@property (nonatomic) UIView *icons;
@property (nonatomic) UIImageView *lapIcon;
@property (nonatomic) UIImageView *playIcon;
@property (nonatomic) UIImageView *restIcon;
@property (nonatomic) UIImageView *pauseIcon;
@property (nonatomic) UILabel *lblCountLap;
@property (nonatomic) UILabel *lblTimeRest;
@property (nonatomic) UIButton *btnTimeRest;
@property (nonatomic) UIView *restView;

//Timer Do cronometro
@property (nonatomic) NSTimer *timeController;

//Informacoes do cronometro
@property (nonatomic) short focus;
@property (nonatomic) int restTime;

//PickerView Contents
@property (nonatomic) UIView *pickerView;
@property (nonatomic) PickerView_Model *picker;
@property (nonatomic) UIButton *pickerButton;

//Formatacao para apresentacao
@property (nonatomic) NSDateFormatter *formatterChronometer;
@property (nonatomic) NSDateFormatter *formatterRest;

//Possiveis coisas a serem mostradas no cronometro, tudo depende do tamanho que ele for ocupar na tela
@property (nonatomic) UILabel *lblChronometer;
@property (nonatomic) UITextField *txtChronometerName;
@property (nonatomic) UILabel *lblChronometerBestLap;
@property (nonatomic) TableView_Model *tbLaps;

//Arrays para manipular o tempo do cronometro
@property (nonatomic) NSMutableArray *pauseTimes;
@property (nonatomic) NSMutableArray *startTimes;
@property (nonatomic) NSMutableArray *lapTimes;
@property (nonatomic) NSMutableArray *chronometerTimeAtLap;
@property (nonatomic) NSMutableArray *pausedTimeUntilLap;

//Gambiarra
@property (nonatomic) BOOL onlyMS;

@end

@implementation Chronometer

#pragma mark - Instance Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.lapIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_volta@2x.png"]];
        self.playIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_play@2x.png"]];
        self.pauseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pause_grande@2x.png"]];
        self.restIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icone_return@2x.png"]];
        self.lblCountLap = [[UILabel alloc] init];
        
        self.icons = [[UIView alloc] init];
        
        self.maskView = [[UIView alloc] init];
        
        self.currentTime = [NSNumber numberWithFloat:0];
        self.pausedTime = [NSNumber numberWithFloat:0];
        
        //Inicia todos os arrays controladores de tempo
        self.pauseTimes = [[NSMutableArray alloc] init];
        self.startTimes = [[NSMutableArray alloc] init];
        self.lapTimes = [[NSMutableArray alloc] init];
        self.chronometerTimeAtLap = [[NSMutableArray alloc] init];
        self.pausedTimeUntilLap = [[NSMutableArray alloc] init];
        
        //Define como sera a formatacao para o tempo do cronometro
        self.formatterChronometer = [[NSDateFormatter alloc] init];
        [self.formatterChronometer setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        
        //define como sera a formatacao do tempo para o descanso
        self.formatterRest = [[NSDateFormatter alloc] init];
        [self.formatterRest setDateFormat:@"mm:ss.SS"];
        [self.formatterRest setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        
        self.inRest = false;
        
        self.name = @"Giovani";
        
        //Aloca e ajusta o texto das labels
        [self adjustLabelTexts];
    }
    return self;
}

#pragma mark - Chronometer Configuration

-(void)enableEditing
{
    if (self.isEditable) {
        //Caso esteja editavel, chamou essa funcao de novo, para de ser editavel
        self.isEditable = false;
        self.txtChronometerName.enabled = self.isEditable;
        
        [self editChronometerName:self.txtChronometerName.text];
        
        self.picker = nil;
        
        [self resizeCronometer:self.frame andFocus:CRONOMETRO_INTERMEDIARIO];
    }else{
        //Para caso nao esteja editavel, passa a ser editavel
        self.isEditable = true;
        
        [self resizeCronometer:self.frame andFocus:CRONOMETRO_EDITAVEL];
    }
}

//Atualiza os icones na tela (volta e play)
-(void)updateIcons
{
    //Remove tudo da tela para nao ter lixo...
    [self.icons removeFromSuperview];
    [self.lapIcon removeFromSuperview];
    [self.playIcon removeFromSuperview];
    [self.lblCountLap removeFromSuperview];
    [self.pauseIcon removeFromSuperview];
    [self.maskView removeFromSuperview];
    [self.pauseIcon removeFromSuperview];
    [self.restIcon removeFromSuperview];
    
    //Adiciona o icone e o numero de voltas
    if ([self.lapTimes count] > 0) {
        if (self.frame.size.width < 100) {
//            NSLog(@"%f", self.frame.size.width);
            self.lapIcon.frame = CGRectMake(5, 5, 10, 10);
            
            self.lblCountLap.frame = CGRectMake(20, 5, 40, 11);
            int lblTextSize = MIN(self.lblCountLap.frame.size.width, self.lblCountLap.frame.size.height);
            self.lblCountLap.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize];
        }else if(self.frame.size.width < 200){
            self.lapIcon.frame = CGRectMake(10, 10, 21, 15);
            
            self.lblCountLap.frame = CGRectMake(35, 7, 50, 20);
            int lblTextSize = MIN(self.lblCountLap.frame.size.width, self.lblCountLap.frame.size.height);
            self.lblCountLap.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize];
        }else{
//            NSLog(@"%f", self.frame.size.width);

            self.lapIcon.frame = CGRectMake(15, 10, 21, 15);
            
            self.lblCountLap.frame = CGRectMake(45, 7, 50, 20);
            
            int lblTextSize = MIN(self.lblCountLap.frame.size.width, self.lblCountLap.frame.size.height);
            self.lblCountLap.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize * 0.9];
        }
        
        [self.icons addSubview:self.lapIcon];
        
        self.lblCountLap.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.lapTimes count]];
        self.lblCountLap.textColor = [UIColor whiteColor];
        
        [self.icons addSubview:self.lblCountLap];
    }
    
    //Adiciona o simbolo de play se o cronometro estiver rodando
    if ([self.startTimes count] > [self.pauseTimes count]) {
        if (self.frame.size.width < 100) {
            self.playIcon.frame = CGRectMake(self.icons.frame.size.width - 15, 5, 10, 10);
        }else{
            self.playIcon.frame = CGRectMake(self.icons.frame.size.width - 40, 10, 15, 15);
        }
        [self.icons addSubview:self.playIcon];
    }
    
    //Adiciona a mascara e o simbolo de pausa
    if ([self.startTimes count] == [self.pauseTimes count]) {
        if (self.inRest == false) {
            self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            self.pauseIcon.frame = CGRectMake(self.frame.size.width - 60, 10, 40, 40);
            
            [self.maskView addSubview:self.pauseIcon];
            
            [self addSubview:self.maskView];
        }else{
            self.restIcon.frame = CGRectMake(self.icons.frame.size.width - 40, 10, 15, 15);
            [self.icons addSubview:self.restIcon];
        }
    }
    
    [self addSubview:self.icons];
}

//Metodo que vai alterar a organizaçao do espaço da view
//Sem condiçoes de implementar sem saber como sera o espaço
-(void)resizeCronometer:(CGRect)size andFocus:(int)focus
{
    //Lembrar de alignment Center, AdjustFontSizeToFitWidht, minimunScaleFactor(????)
    self.focus = focus;
    self.frame = size;
    
    int const origin = 0;   //Define o ponto de origem dos rects a serem criados
    
    int screenDivisions;
    
    //Retira tudo da tela, para nao haver sobreposicao de itens na tela
    [self.lblChronometer removeFromSuperview];
    [self.lblChronometerBestLap removeFromSuperview];
    [self.txtChronometerName removeFromSuperview];
    [self.tbLaps removeFromSuperview];
    [self.icons removeFromSuperview];
    
    //Torna o textfield nao editavel
    self.txtChronometerName.enabled = false;
    
    switch (self.focus) {
            
            //MOSTRA O NOME E O TEMPO
            //Divide o cronometro em 4 partes:
            //1/4 - icones de volta e play
            //2/4 - tempo do cronometro
            //1/4 - nome do cronometro
        case CRONOMETRO_BASE:
            screenDivisions = 6;    //Seta em quantos pedacos a view em que o cronometro aparecera sera mostrado
            
            [self.icons setFrame:CGRectMake(origin, origin, self.frame.size.width, (self.frame.size.height / screenDivisions))];
            
            [self updateIcons];
            
            //atribui pedacos da tela as labels que mostram o nome e o tempo
            [self.lblChronometer setFrame:CGRectMake(5, (self.frame.size.height / screenDivisions), self.frame.size.width - 10, (self.frame.size.height / screenDivisions) * 3)];
            
            [self.txtChronometerName setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions) * 4, self.frame.size.width, (self.frame.size.height / screenDivisions) * 2)];
            
            break;
            
            //MOSTRA O NOME, TEMPO E AS LAPS
            //Divide o frame do cronometro em 5 partes
            // - 1/6 fica com o a label que contem o nome do cronometro
            // - 2/6 ficam com o label que mostra o tempo
            // - 3/6 ficam com o a table viwe que mostra todas as lap
        case CRONOMETRO_INTERMEDIARIO:
        {
            screenDivisions = 8;    //Seta em quantos pedacos a view em que o cronometro aparecera sera mostrado
            
            [self.txtChronometerName setFrame:CGRectMake(origin, origin, self.frame.size.width, (self.frame.size.height / screenDivisions) * 2)];
            
            [self.icons setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions) * 2, self.frame.size.width, (self.frame.size.height / screenDivisions))];
            [self updateIcons];
            
            [self.lblChronometer setFrame:CGRectMake(5, (self.frame.size.height / screenDivisions) * 3, self.frame.size.width - 10, (self.frame.size.height / screenDivisions) * 2)];
            
            //Define o tamanho que a tableview com as laps ocupara
            CGRect tableViewLapsSize = CGRectMake(origin, (self.frame.size.height / screenDivisions) * 5, self.frame.size.width, (self.frame.size.height / screenDivisions) * 3);
            
            //Instancia uma tableview com o tamanho definido
            self.tbLaps = [[TableView_Model alloc] initWithFrame:tableViewLapsSize
                                                        LapTimes:[self formattedLapContents]
                                    andchronometerTotalTimeAtLap:[self formattedChronometerTimeAtLaps]];
            
            //Adiciona a tableview a tela
            [self addSubview:self.tbLaps];
            
            break;
        }
            
            //MOSTRA O NOME, O TEMPO, AS LAPS E A MELHOR LAP
            //Divide a tela aem 7 pedacos:
            // - 1/7 fica com a label que mostra o nome do cronometro na tela
            // - 2/7 ficam com a label que mostra o tempo que esta sendo marcado na tela
            // - 3/7 ficam com a table view que mostra as laps do cronometro
            // - 1/7 fica com a label que mostra qual a melhor volta até o momento
        case CRONOMETRO_COMPLETO:
        {
            screenDivisions = 9;    //Seta em quantos pedacos a view em que o cronometro aparecera sera mostrado
            
            [self.txtChronometerName setFrame:CGRectMake(origin, origin, self.frame.size.width, (self.frame.size.height / screenDivisions) * 2)];
            
            [self.icons setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions) * 2, self.frame.size.width, (self.frame.size.height / screenDivisions))];
            [self updateIcons];
            
            [self.lblChronometer setFrame:CGRectMake(5, (self.frame.size.height / screenDivisions) * 3, self.frame.size.width - 10, (self.frame.size.height / screenDivisions) * 2)];
            
            //Define o tamanho que a tableview com as laps ocupara
            CGRect tableViewLapsSize = CGRectMake(origin, (self.frame.size.height / screenDivisions) * 5, self.frame.size.width, (self.frame.size.height / screenDivisions) * 3);
            
            //separa um pedaco da tela para a label que vai mostrar a melhor volta
            [self.lblChronometerBestLap setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions) * 8, self.frame.size.width, self.frame.size.height / screenDivisions)];
            
            //Instancia uma tableview com o tamanho definido
            self.tbLaps = [[TableView_Model alloc] initWithFrame:tableViewLapsSize
                                                        LapTimes:[self formattedLapContents]
                                    andchronometerTotalTimeAtLap:[self formattedChronometerTimeAtLaps]];
            
            self.lblChronometerBestLap.text = [NSString stringWithFormat:@"Best Lap: %@", [self timeFormatter:[self bestLap]]];
            
            //adiciona a tableview e a label com o melhor tempo a tela
            [self addSubview:self.tbLaps];
            [self addSubview:self.lblChronometerBestLap];
            
            break;
        }
            
            //para caso o cronometro seja editavel
        case CRONOMETRO_EDITAVEL:
        {
            screenDivisions = 12;    //Seta em quantos pedacos a view em que o cronometro aparecera sera mostrado
            
            [self.txtChronometerName setFrame:CGRectMake(origin, origin, self.frame.size.width, (self.frame.size.height / screenDivisions * 2))];
            self.txtChronometerName.enabled = self.isEditable;
            
            [self.icons setFrame:CGRectMake(origin, (self.frame.size.height / screenDivisions) * 2, self.frame.size.width, (self.frame.size.height / screenDivisions))];
            [self updateIcons];
            
            [self.lblChronometer setFrame:CGRectMake(5, (self.frame.size.height / screenDivisions) * 3, self.frame.size.width - 10, (self.frame.size.height / screenDivisions) * 2)];
            
            //Define o tamanho que a tableview com as laps ocupara
            CGRect tableViewLapsSize = CGRectMake(origin, (self.frame.size.height / screenDivisions) * 5, self.frame.size.width, (self.frame.size.height / screenDivisions) * 4);
            
            //Instancia uma tableview com o tamanho definido
            self.tbLaps = [[TableView_Model alloc] initWithFrame:tableViewLapsSize
                                                        LapTimes:[self formattedLapContents]
                                    andchronometerTotalTimeAtLap:[self formattedChronometerTimeAtLaps]];
            
            self.restView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height / screenDivisions) * 10, self.frame.size.width, (self.frame.size.height / screenDivisions) * 2)];
            self.restView.backgroundColor = [UIColor whiteColor];
            self.restView.layer.cornerRadius = 5;
            self.restView.layer.masksToBounds = YES;
            
            self.lblTimeRest = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.restView.frame.size.width - 80, self.restView.frame.size.height)];
            
            int lblTextSize = MIN(self.lblTimeRest.frame.size.width, self.lblTimeRest.frame.size.height);
            self.lblTimeRest.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize * 0.5];
            self.lblTimeRest.adjustsFontSizeToFitWidth = YES;
            self.lblTimeRest.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            
            self.btnTimeRest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [self.btnTimeRest setFrame:CGRectMake(self.restView.frame.size.width - 78, 0, 78, self.restView.frame.size.height)];
            
            [self.btnTimeRest addTarget:self action:@selector(editRestTime) forControlEvents:UIControlEventTouchUpInside];
            self.btnTimeRest.titleLabel.textColor = [UIColor blackColor];
            
            //Gambiarra pra mostrar so Minutos e segundos de forma rapida
            self.onlyMS = true;
            [self.btnTimeRest setTitle:[NSString stringWithFormat:@"%@", [self timeFormatter:[NSNumber numberWithFloat:self.restTime]]] forState:UIControlStateNormal];
            self.onlyMS = false;
            
            lblTextSize = MIN(self.btnTimeRest.frame.size.width, self.btnTimeRest.frame.size.height);
            self.btnTimeRest.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize * 0.3];
            
            self.lblTimeRest.text = @"Rest Time:";
            self.lblTimeRest.textAlignment = NSTextAlignmentCenter;
            
            [self.restView addSubview:self.lblTimeRest];
            [self.restView addSubview:self.btnTimeRest];
            
            [self addSubview:self.restView];
            
            //Adiciona a tableview a tela
            [self addSubview:self.tbLaps];
            
            break;
        }
            
    }
    
    //Ajusta a fonte e o tamanho do texto para a label que mostra o nome do cronometro
    int lblTextSize = MIN(self.txtChronometerName.frame.size.width, self.txtChronometerName.frame.size.height);
    self.txtChronometerName.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize * 0.8];
    
    //Ajusta a fonte e o tamanho do texto para a lael que mostra o nome do cronoetro
    lblTextSize = MIN(self.lblChronometer.frame.size.width, self.lblChronometer.frame.size.height);
    self.lblChronometer.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize * 0.95];
    
    //Ajusta a fonte e o tamanho od texto para alabel que mostra o nome do cronometro
    lblTextSize = MIN(self.lblChronometerBestLap.frame.size.width, self.lblChronometerBestLap.frame.size.height);
    self.lblChronometerBestLap.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize * 0.8];
    
    //Adiciona o nome do cronometro ao label que mostra o nome do cronometro
    [self editChronometerName:self.name];
    
    //Adiciona as labels que mostram o nome e o tempo do cronometro a tela
    [self addSubview:self.txtChronometerName];
    [self addSubview:self.lblChronometer];
}

//Ajusta todas as labels, para facilitar edicao dos textos das labels futuramente
-(void)adjustLabelTexts
{
    self.lblChronometer = [[UILabel alloc] init];
    self.lblChronometerBestLap = [[UILabel alloc] init];
    self.txtChronometerName = [[UITextField alloc] init];
    
    self.lblChronometer.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.lblChronometerBestLap.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //    self.lblChronometerName.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    self.lblChronometer.textColor = [UIColor whiteColor];
    self.lblChronometerBestLap.textColor = [UIColor whiteColor];
    self.txtChronometerName.textColor = [UIColor whiteColor];
    
    self.txtChronometerName.textAlignment = NSTextAlignmentCenter;
    self.lblChronometerBestLap.textAlignment = NSTextAlignmentCenter;
    self.lblChronometer.textAlignment = NSTextAlignmentCenter;
    
    self.txtChronometerName.adjustsFontSizeToFitWidth = YES;
    self.lblChronometerBestLap.adjustsFontSizeToFitWidth = YES;
    self.lblChronometer.adjustsFontSizeToFitWidth = YES;
    
    self.lblChronometer.text = [self timeFormatter:0];  //Faz o cronometro mostrar 0
    
}

//Atualiza o texto da label ao mesmo em que o nome do cronometro foi alterado, sem necessidade de arranjar um jeito de dar refresh na tela
-(void)editChronometerName:(NSString*)name
{
    self.name = name;
    self.txtChronometerName.text = self.name;
}

//Ajusta o tempo de descanso do cronometro
-(void)editRestTime
{
    self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, (self.frame.size.height / 3) * 2)];
    self.pickerView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.pickerView.backgroundColor = [UIColor whiteColor];
    
    self.pickerView.layer.cornerRadius = 5;
    self.pickerView.layer.masksToBounds = YES;
    
    self.pickerButton.layer.cornerRadius = 5;
    self.pickerButton.layer.masksToBounds = YES;
    
    self.picker = [[PickerView_Model alloc] initWithFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, (self.pickerView.frame.size.height / 3) * 2)];
    
    self.pickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pickerButton addTarget:self action:@selector(confirmedRestTime) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.pickerButton setBackgroundColor:[UIColor purpleColor]];
    
    self.pickerButton.frame = CGRectMake(0, (self.pickerView.frame.size.height / 3) * 2, self.pickerView.frame.size.width, (self.pickerView.frame.size.height / 3));
    
    int lblTextSize = MIN(self.pickerButton.frame.size.width, self.pickerButton.frame.size.height);
    self.pickerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:lblTextSize * 0.4];
    [self.pickerButton setTitle:@"Confirm" forState:UIControlStateNormal];
    
    [self.pickerView addSubview:self.picker];
    [self.pickerView addSubview:self.pickerButton];
    [self addSubview:self.pickerView];
}

-(void)confirmedRestTime
{
    
    NSTimeInterval time = ((self.picker.min * 60) + self.picker.sec);
    self.restTime = time;
    
    //Gambiarra pra mostrar so Minutos e Segundos
    self.onlyMS = true;
    self.btnTimeRest.titleLabel.text = [self timeFormatter:[NSNumber numberWithFloat:time]];
    self.onlyMS = false;
    
    [self.pickerView removeFromSuperview];
    
    self.pickerButton = nil;
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    
    if (self.inRest) {
        [self.timeController invalidate];
        self.timeController = nil;
        self.inRest = false;
        self.lblChronometer.text = [self timeFormatter:self.currentTime];
        [self updateIcons];
        [self enableEditing];
    }
}

//formata um numero (tempo) em uma string formatada e apresentavel
-(NSString*)timeFormatter:(NSNumber*)timeInSeconds
{
    //calculo de horas e minutos a partir dos segundos
    NSUInteger h = (NSUInteger)[timeInSeconds floatValue] / 3600;
    
    //Verifica que informacoes necessitam ser mostradas
    if (h >= 1) {
        [self.formatterChronometer setDateFormat:@"HH:mm:ss.SS"];
    }else{
        [self.formatterChronometer setDateFormat:@"mm:ss.SS"];
    }
    if (self.onlyMS) {
        [self.formatterChronometer setDateFormat:@"mm:ss"];
    }
    
    //transforma o tempo do cronometro em uma NSDate
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:[timeInSeconds floatValue]];
    
    return [self.formatterChronometer stringFromDate:timerDate];
}

#pragma mark - Time Control Methods

//Zera o cronometro
-(void)resetChronometer
{
    //faz o cronometro parar de rodar
    if (!(self.timeController == nil)) {
        [self.timeController invalidate];
        self.timeController = nil;
    }
    
    //limpa os array que contem os tempos do cronometro
    [self.lapTimes removeAllObjects];
    [self.pauseTimes removeAllObjects];
    [self.startTimes removeAllObjects];
    [self.chronometerTimeAtLap removeAllObjects];
    
    //define a melhor volta como zero
    self.lblChronometerBestLap.text = [self timeFormatter:0];
    
    //atualiza a tableView
    [self.tbLaps refreshTableViewWithLapTimes:[self formattedLapContents] andchronometerTotalTimeAtLap:[self formattedChronometerTimeAtLaps]];
//    self.
    
    //zera o cronometro que aparece na tela
    self.lblChronometer.text = [self timeFormatter:0];
    [self pauseChronometer];
}

-(void)playChronometer
{
    //    if (self.isEditable) {
    //        [self enableEditing];
    //    }
    
    //Foi necessario recolocar essa validacao aqui, pois esse metodo sera chamado de uma classe exterior diretamente
    if (![self.timeController isValid]) {//Verifica se o cronometro está parado
        //Ativa o cronometro
        self.timeController = [NSTimer scheduledTimerWithTimeInterval:0.045
                                                               target:self
                                                             selector:@selector(updateChronometer)
                                                             userInfo:nil repeats:YES];
        //Adiciona ao array de inicio o momento em que o cronometro começou a correr
        [self.startTimes addObject:[NSDate date]];
        
        self.pausedTime = [self getTimeOfPause];
        
        //Faz o timer correr em um loop separado do loop da aplicacao, evitando o problema de para atualizacao da label do cronometro
        [[NSRunLoop currentRunLoop] addTimer:self.timeController
                                     forMode:NSRunLoopCommonModes];
        
        [self updateIcons]; //Atualiza os icones da tela
    }
}

-(void)pauseChronometer
{
    //    if (self.isEditable) {
    //        [self enableEditing];
    //    }
    
    //Necessario recolocar essa validacao pq esse metodo sera chamado de uma classe exterior
    if ([self.timeController isValid]) {
        //Destroi o timer do cronometro, resultando na nao atualizaçao do cronometro
        [self.timeController invalidate];
        
        //Libera a memoria ocupada pelo timer
        self.timeController = nil;
        
        //Adiciona ao array de pausas o momento em que o cronometro foi pausado
        [self.pauseTimes addObject:[NSDate date]];
        
        
        //se fica dentro ele nao da update algumas vezes.... by camila. 
//        [self updateIcons];
    }
    [self updateIcons];
}

//Controlador de tempo do cronometro, dividi o play e pause em dois metodos pq precisava chamar o pause manualmente algumsa vezes
-(void)play_pauseChronometer
{
    if (self.inRest) {
        [self.timeController invalidate];
        self.timeController = nil;
        self.inRest = false;
        self.lblChronometer.text = [self timeFormatter:self.currentTime];
        [self updateIcons];
    }else{
        if (![self.timeController isValid]) {//Verifica se o cronometro está parado
            [self playChronometer];
        }else{   //Caso o cronometro ja esteja ativo
            [self pauseChronometer];
        }
    }
}

-(void)restChronometer
{
    //Verifica se o cronometro já está em modo descanso
    if (self.inRest == false) {
        
        if (self.isEditable) {
            [self enableEditing];
        }
        
        self.inRest = true;
        
        if ([self.startTimes count] > [self.pauseTimes count]) {
            [self pauseChronometer]; //Garante que o cronometro sera pausado na hora da execucao
        }
        
        [self updateIcons];
        
        self.startRest = [NSDate date]; //Guarda a hora de inicio do tempo de descanso
        
        //starta o timer para chamar o metodo update rest a cada 100 milisegundos
        
        self.timeController = [NSTimer scheduledTimerWithTimeInterval:0.045 target:self selector:@selector(updateRest) userInfo:nil repeats:YES];
        
        //Faz o timer correr em um loop separado do loop da aplicacao, evitando o problema de para atualizacao da label do cronometro
        [[NSRunLoop currentRunLoop] addTimer:self.timeController
                                     forMode:NSRunLoopCommonModes];
    }
}

//Marca uma volta no cronometro
-(void)lapChronometer
{
    if (!([[self startTimes] count] == [[self pauseTimes] count])) {
        
//        if (self.isEditable) {
//            [self enableEditing];
//        }
        
        //Adiciona ao array de voltas o momento em que foi solicitado uma volta
        [self.lapTimes addObject:[NSDate date]];
        
        if ([self.pausedTimeUntilLap count] > 0) {
            float count;
            for (int i = 0; i < [self.pausedTimeUntilLap count]; i++) {
                count += [[self.pausedTimeUntilLap objectAtIndex:i] floatValue];
            }
            
            [self.pausedTimeUntilLap addObject:[NSNumber numberWithFloat:[[self getTimeOfPause] floatValue] - count]];
        }else{
            [self.pausedTimeUntilLap addObject:[NSNumber numberWithFloat:[[self getTimeOfPause] floatValue]]];
        }
        
        [self updateChronometer];
        [self.chronometerTimeAtLap addObject:self.currentTime];
        [self.tbLaps refreshTableViewWithLapTimes:[self formattedLapContents] andchronometerTotalTimeAtLap:[self formattedChronometerTimeAtLaps]];
        self.lblChronometerBestLap.text = [NSString stringWithFormat:@"Best Lap: %@", [self timeFormatter:[self bestLap]]];
        
        [self updateIcons];
        
        //Faz com que o iphone vibre quando uma volta for marcada
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

//Atualiza o tempo do descanso
-(void)updateRest
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate
                                   timeIntervalSinceDate:self.startRest];
    
    NSTimeInterval timeIntervalCountDown = self.restTime - timeInterval;
    
    self.lblChronometer.text = [self timeFormatter:[NSNumber numberWithFloat:timeIntervalCountDown]];
    
    if (timeIntervalCountDown <= 0) {
        [self.timeController invalidate];
        self.timeController = nil;
        self.inRest = false;
        
        if ([self.pauseTimes count] == 0) {
            self.lblChronometer.text = [self timeFormatter:0];
        }else{
            self.lblChronometer.text = [self timeFormatter:self.currentTime];
        }
        [self updateIcons];
    }
}

//Método que altera o texto contido na label, mostrando o tempo do relogio
-(void)updateChronometer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval;
    
    if ([self.pauseTimes count] > 0){       //Verifica se o cronometro ja foi pausado alguma vez
        timeInterval = [[NSDate date] timeIntervalSinceDate:[self.startTimes firstObject]];
        timeInterval -= [self.pausedTime floatValue];
    }else       //Caso o cronometro nao tenha sido pausado nenhuma vez
    {
        timeInterval = [currentDate timeIntervalSinceDate:[self.startTimes lastObject]];
    }
    
    self.currentTime = [NSNumber numberWithFloat:timeInterval];
    
    //Chama a funcao de formatacao de tempo para mostrar o texto de forma bela kkk
    NSString *timeString = [self timeFormatter:self.currentTime];
    self.lblChronometer.text = timeString;
}

#pragma mark - Returning Informations

-(NSArray*)getStartTimes
{
    return self.startTimes;
}

-(NSArray*)getPauseTimes
{
    return self.pauseTimes;
}

//Retorna o tempo de pausa total do cronometro
-(NSNumber*)getTimeOfPause
{
    NSTimeInterval timeOfPause = 0.0;   //Conta a quantidade de tempo que o cronometro ficou parado
    for (int i = 0; i < [self.pauseTimes count]; i++) {     //Percorre o array que armazena todas as pausas
        //Adiciona ao contador, todo o tempo entre a pausa e o proximo start
        timeOfPause += [[self.startTimes objectAtIndex:i + 1] timeIntervalSinceDate:[self.pauseTimes objectAtIndex:i]];
    }
    return [NSNumber numberWithFloat:timeOfPause];
}

//calcula a melhor volta entre as marcadas
-(NSNumber*)bestLap
{
    //Verifica se ja foi marcada alguma volta para nao ocorrer erros
    if ([self.lapTimes count] == 0) {
        return nil;
    }else{
        
        
        //Variavel auxiliar, para nao precisar chamar o metodo toda hora
        NSArray *laps = [self getLapsContent];
        
        //melhor volta e igual a primeira volta
        NSNumber *bestLap = [laps firstObject];
        
        if ([laps count] > 1) {
            //Percorre a partir da segunda posicao
            for (int i = 1; i < [laps count]; i++) {
                //verifica o valor dos numeros para saber qual e o menor
                if ([[laps objectAtIndex:i] floatValue] < [bestLap floatValue]) {
                    //melhor volta passa a ser a menor
                    bestLap = [laps objectAtIndex:i];
                }
            }
        }
        
        return bestLap;
    }
}

//Retorna o tempo de cada volta
-(NSArray*)getLapsContent
{
    NSMutableArray *lapContents = [[NSMutableArray alloc] init];
    NSTimeInterval interval = 0.0;
    
    //verifica se ja foi marcada alguma volta
    if ([self.lapTimes count] == 0) {
        return nil;
        
    }else{
        
        //Calcula o tempo entre a primeira volta e o horario de inicio do cronometro
        //Evita passar por if toda hora dentro do loop
        interval = [[self.lapTimes firstObject] timeIntervalSinceDate:[self.startTimes firstObject]];
        interval -= [[self.pausedTimeUntilLap objectAtIndex:0] floatValue];
        [lapContents addObject:[NSNumber numberWithFloat:interval]];
        
        //Percorre o array de voltas, a partir da segunda volta
        for (int i = 1; i < [self.lapTimes count]; i++) {
            interval = 0;
            
            //Calcula o intervalo de tempo entre a volta atual e a volta passada
            interval = [self.lapTimes[i] timeIntervalSinceDate:self.lapTimes[i - 1]];
            interval -= [[self.pausedTimeUntilLap objectAtIndex:i] floatValue];
            NSNumber *numb = [NSNumber numberWithFloat:interval];
            
            [lapContents addObject:numb];
        }
        
        return lapContents;
    }
}

//Retorna um array contendo:
//- NSDate de inicio do cronometro
//- de 0 a N NSNumber contendo o tempo de cada volta
//Ou nao retorna nada se nao tiver nenhuma volta
-(NSArray*)getChronometerContent
{
    NSMutableArray *lapContents = [[NSMutableArray alloc] init];
    
    //adicionando o NSDate de quando o cronometro foi startado
    [lapContents addObject:[self.startTimes firstObject]];
    
    [lapContents addObjectsFromArray:[self getLapsContent]];
    
    return lapContents;
}

#pragma mark - TableView Fulfill

//Pega o tempo do cronometro formatado no momento da volta
-(NSArray*)formattedChronometerTimeAtLaps
{
    NSMutableArray *timeStg = [[NSMutableArray alloc] init];
    
    for (NSNumber *numb in self.chronometerTimeAtLap) {
        [timeStg addObject: [self timeFormatter:numb]];
    }
    
    return timeStg;
}

//retorna o momento em que as voltas foram marcadas de forma padronizada e como string para melhor apresentacao na tableview
-(NSArray*)formattedLapTimes
{
    //Configuracoes do formato de data a ser utilizado
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone localTimeZone]];    //Era pra deixar a timeZone localizada (n sei se funfou)
    [df setDateFormat:@"MMM - dd: HH:mm"];  //Define como que sera mostrado a data
    
    //array auxiliar que armazenara as strings formatadas
    NSMutableArray *formattedSelectedLaps = [[NSMutableArray alloc] init];
    
    //percorre todos os momentos em que as voltas foram marcadas
    for (NSDate *date in self.lapTimes) {
        //formata a data em que a volta foi marcada para o formato desejdo
        [formattedSelectedLaps addObject:[df stringFromDate:date]];
    }
    
    return formattedSelectedLaps;
}

//Retorna um array de strings formatados atraves da funcao timeFormatter
-(NSArray*)formattedLapContents
{
    //Array auxiliar para armazenar as strings de tempo
    NSMutableArray *formattedTimes = [[NSMutableArray alloc] init];
    
    //percorre todos os objetos do vetor e chama a funcao que formata eles para string
    for (NSNumber *n in [self getLapsContent]) {
        [formattedTimes addObject:[self timeFormatter:n]];
    }
    
    return formattedTimes;
}

@end