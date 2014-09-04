/*
 * Main program for a general purpose IO board with RS-232 connection to the host computer. Currently, the only input is
 * a capacitive button for use with the hand manipulator.
 *
 * -> Capacitive Button - pin 23 (PORTC 0)
 *
 *	avrdude -c avrispmkII -p m328p -U lfuse:w:0xff:m -U hfuse:w:0xd9:m -U efuse:w:0xff:m -U flash:w:filename.hex
 *
 */ 

#define F_CPU 20000000UL	// 20MHz

#include <avr/io.h>
#include <stdio.h>
#include <avr/interrupt.h>
#include <string.h>

#define BAUD 115200
#define MYUBRR (((((F_CPU * 10) / (16L * BAUD)) + 5) / 10) - 1)	// calculate UBRR value for current baud rate
#define BUFFLEN 10

#define ADC_CHAN(chan) (ADMUX = (ADMUX & 0b11110000) | (chan & 0b00001111))
#define CAP_CHAN 0				// current pin for capacitive button
#define BEND_CHAN_START 1		// start pin of the current bank of bend sensors
#define NUM_BEND_SENSORS 5		// how many bend sensors are hooked up currently? (max = 5)
#if NUM_BEND_SENSORS > 5
	#error "Number of bend sensors must be no more than 5"
#endif
#define NUM_BITS (10*(1+NUM_BEND_SENSORS))	// Total number of bits for all ADC values
#define ADC_GND 15				// ADC mux channel for ground
#define NUM_AVG 3				// how many readings to average together?

volatile char rxbuffer[BUFFLEN];	// at 115200 bps, we can send/receive 11.5 packets (10 bits/packet) every millisecond
volatile uint8_t rxnum = 0;			// current number of messages in the buffer
volatile char txbuffer[BUFFLEN];
volatile uint8_t txnum = 0;
volatile char rxoverflow = 0;		// set to 1 if current rx'd byte won't fit in the buffer (unused for now)

void initMCU(void);
uint16_t readADCChan(uint8_t chan);
uint16_t * getADC();
uint8_t * packBytes(uint16_t *values, uint8_t *packsize);

int main(void)
{
	uint8_t *valspack;		// array of packet data bytes + header
	uint8_t *packsize;		// size in bytes of the packed array
	initMCU();
	sei();

    while(1)
    {
		
		if (TIFR1 & (1<<OCF1A))	//1ms timer -> read inputs, send to host
		{
			valspack = packBytes(getADC(), packsize); //read and pack ADC values

			memcpy(txbuffer, valspack, *packsize);	//copy to transmit buffer
			txnum = *packsize;

			UCSR0B |= (1<<UDRIE0);	//enable interrupt on data register empty (enable serial transmit)
			TIFR1 = (1<<OCF1A); //clear timer flag
		}			
        
    }
}

// Pack all 10-bit values to be sent into an array of bytes:
uint8_t * packBytes(uint16_t *adcvals, uint8_t *packsize)
{
	uint8_t i;
	uint64_t tempdata = 0;
	static uint8_t packedbytes[((NUM_BITS%8) ? ((NUM_BITS>>3) + 1):(NUM_BITS>>3)) + 2];
	
	memset(packedbytes, 0, sizeof(packedbytes));		//Clear the return values
	packedbytes[0] = '-';	//header byte 1
	packedbytes[1] = '>';	//header byte 2

	for (i = 0; i < 1+NUM_BEND_SENSORS; i++)
		tempdata |= ((uint64_t)adcvals[i] << (i * 10));			//Add 10bit vals to temp
	
	for (i = 0; i < (sizeof(packedbytes)-2); i++)
		packedbytes[i+2] = (tempdata >> (i * 8)) & 0xFF;			//Take out each byte in turn
	
	*packsize = sizeof(packedbytes);
	
	return packedbytes;
}

// Read capacitive button and all currently attached bend sensors (set pins/number in #define section):
uint16_t * getADC()
{
		uint16_t avgval = 0;
		static uint16_t retvals[NUM_BEND_SENSORS + 1];	//Array of 16-bit words (10-bit ADC vals) for bends + 1 cap. sensor
		int i, j;
		
		//Clear return values:
		memset(retvals, 0, sizeof(retvals));
		
		//1st, read capacitive button:
		//Technique used as described in http://tuomasnylund.fi/drupal6/content/capacitive-touch-sensing-avr-and-single-adc-pin
		for (i = 0; i < NUM_AVG; i++)
		{
			PORTC |= (1<<CAP_CHAN);				//Turn on cap. button pull-up resistor to charge it to VCC (5V)
			readADCChan(ADC_GND);				//Do conversion on ground to discharge sampling capacitor (0V)
			PORTC &= ~(1<<CAP_CHAN);			//Turn off pull-up resistor to connect to ADC
			avgval += readADCChan(CAP_CHAN);	//Do conversion on cap. button
		}		
		
		retvals[0] = (avgval/4);				//Return average value (sum/4)
		
		//2nd, read all currently attached sensors:
		for (j = 0; j < NUM_BEND_SENSORS; j++)
		{
			avgval = 0;
			
			for (i = 0; i < NUM_AVG; i++)
				avgval += readADCChan(BEND_CHAN_START+j);
				
			retvals[j+1] = (avgval/4);
		}
		
		return retvals;
}

// Read ADC channel value:
uint16_t readADCChan(uint8_t chan)
{	
	ADC_CHAN(chan);					//Set current ADC channel

	ADCSRA |= (1<<ADSC);			//Start conversion
	while(!(ADCSRA & (1<<ADIF)));	//Wait for conversion to finish
	ADCSRA |= (1<<ADIF);			//Reset flag
	
	return (uint16_t)ADC;
}

// Initialize the USART, Timer, and ADC:
void initMCU()
{
	// USART setup:
	UBRR0 = MYUBRR;								//Set baud rate
	UCSR0B = (1<<RXEN0)|(1<<TXEN0);				//Enable serial transmit/receive
	
	// ADC setup:
	ADMUX |= (1<<REFS0);						//Set ADC reference voltage to AVCC
	ADCSRA |= (1<<ADEN)|(7<<ADPS0)|(1<<ADSC);	//Enable ADC w/prescaler = 128, start a conversion
	while(!(ADCSRA & (1<<ADIF)));				//Wait for 1st conversion to finish (1st is longer)
	ADCSRA |= (1<<ADIF);						//Clear the flag, enable interrupt
		
	// Timer setup:
	OCR1A = 19999;								//Set flag/reset after 20k steps = 1ms (no prescaler)
	TCCR1B |= (1<<WGM12)|(1<<CS10);
	//OCR1A = 32149; //.1s clock with prescaler=64
	//TCCR1B |= (1<<WGM12)|(1<<CS11)|(1<<CS10);				//CTC, prescaler = 64, start timer
}

// Serial receive complete: read in data byte to rxbuffer
ISR(USART_RX_vect)
{	
	// if the buffer overflows, set a flag and drop the newest message:
	if (rxnum >= BUFFLEN)
	{
		rxoverflow = 1;
		char trash = UDR0;				// read message to trash, to reset the interrupt flag
	}		
	else
		rxbuffer[rxnum++] = UDR0;		// read in new message to current buffer position
}

// Serial tx buffer empty: write next byte on txbuffer to transmit
ISR(USART_UDRE_vect)
{
	if (txnum == 0)	// make sure we have something to send
	{
		UCSR0B &= ~(1<<UDRIE0);	// disable interrupt on data register empty
		return;					// make sure we have something to send
	}
	
	UDR0 = txbuffer[0];						// transmit the first byte in the buffer
	memmove(txbuffer,txbuffer+1, --txnum);	// move the remaining bytes up one
}